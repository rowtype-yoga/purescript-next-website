module Pages.Packages
  (
    -- getServerSideProps
    -- ,
    mkPackages
  ) where

import Prelude

import Components.Page as Page
import Components.Select as Select
import Control.Monad.Except (except)
import Data.Array as Array
import Data.Bifunctor (lmap)
import Data.Either (Either(..), either)
import Data.Eq.Generic (genericEq)
import Data.Foldable (foldMap)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe, fromMaybe, maybe)
import Data.Show.Generic (genericShow)
import Data.Tuple.Nested ((/\))
import Debug (spy)
import Effect.Aff (Aff, Milliseconds(..), attempt, delay)
import Effect.Class (liftEffect)
import Effect.Class.Console (log, logShow)
import Fetch (Method(..), fetch)
import Fetch.Yoga.Json (fromJSON)
import Foreign (ForeignError(..))
import JSURI (encodeURIComponent)
import Markdown.Markdown as Markdown
import Network.RemoteData (RemoteData)
import Network.RemoteData as RD
import Next.Router (query, useRouter)
import Next.Router as Router
import NextUI.NextUI (useTheme)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM as DOM
import React.Basic.DOM.Events (targetValue)
import React.Basic.DOM.Simplified.Generated as R
import React.Basic.Events (handler)
import React.Basic.Hooks (JSX, mkReducer, useEffect, useState')
import React.Basic.Hooks as React
import React.Hooks.UseRemoteData (useRemoteDataDispatch)
import React.Icons (icon_)
import React.Icons.Tb (tbBook2, tbMathFunction, tbPackage, tbSearch)
import React.Util (el)
import Yoga.JSON (class ReadForeign)
import Yoga.JSON as JSON
import Yoga.JSON as YogaJson
import Yoga.JSON.Error (renderHumanError)

type Props =
  { header :: String
  , baseUrl :: String
  }

type DeclarationR =
  ( module :: String
  , title :: String
  , typeOrValue :: String
  , typeText :: Maybe String
  )

type PackageR = (deprecated :: Boolean)

type ModuleR = (module :: String)

data SearchInfo = Declaration { | DeclarationR } | Package { | PackageR } | Module { | ModuleR }

derive instance Generic SearchInfo _
instance Eq SearchInfo where
  eq = genericEq

instance Show SearchInfo where
  show = genericShow

instance ReadForeign SearchInfo where
  readImpl f = do
    { "type": t } :: { "type" :: String } <- YogaJson.readImpl f
    case t of
      "declaration" -> YogaJson.readImpl f <#> Declaration
      "package" -> YogaJson.readImpl f <#> Package
      "module" -> YogaJson.readImpl f <#> Module
      other -> except $ Left (pure $ ForeignError $ "Invalid search info type " <> other)

type SearchResult =
  { info :: SearchInfo
  , markup :: String
  , package :: String
  , text :: String
  -- , url :: String
  , version :: String
  }

data SearchError = SearchError String

derive instance Generic SearchError _
instance Eq SearchError where
  eq = genericEq

instance Show SearchError where
  show (SearchError e) = "Failed to get search results: " <> e

data Action = EditSearchField String | UpdateSearchResult (RemoteData SearchError (Array SearchResult))

type State =
  { searchResult ∷ RemoteData SearchError (Array SearchResult)
  , searchInput :: String
  }

defaultState :: State
defaultState = { searchResult: RD.NotAsked, searchInput: "" }

reduce ∷ State → Action → State
reduce s (UpdateSearchResult searchResult) =
  s { searchResult = searchResult }
reduce s (EditSearchField "") = s { searchInput = "", searchResult = RD.NotAsked }
reduce s (EditSearchField searchInput) = s { searchInput = searchInput }

getSearchResult :: String -> { searchQuery :: String } -> Aff (Either SearchError (Array SearchResult))
getSearchResult baseUrl { searchQuery } = do
  let query = maybe searchQuery identity $ encodeURIComponent searchQuery
  let url = baseUrl <> "/search?q=" <> query
  { status, text, json } ← fetch url
    { method: GET
    , headers: { "Accept": "application/json" }
    }
  case status of
    200 -> do
      searchResult :: Either SearchError (Array SearchResult) <- json <#> YogaJson.read <#> lmap (foldMap renderHumanError >>> SearchError)
      either (logShow) (const $ pure unit) searchResult
      pure searchResult
    statusCode -> do
      body <- text
      let e = "Got invalid response [" <> (show statusCode) <> "]:\n" <> body
      log e
      pure $ Left $ SearchError e

mkPackages :: Page.Component Props
mkPackages = do

  reducer ← mkReducer reduce # liftEffect
  select <- Select.mkSelect
  Page.component "Packages" \{ pursuitUrl } props -> React.do
    state /\ dispatch ← React.useReducer defaultState reducer
    buttonState /\ setButtonState <- useState' Select.All
    { theme, isDark } <- useTheme
    router <- useRouter
    let
      q :: { q :: String }
      q = query router # JSON.read_ # fromMaybe {q: ""}

      dispatchRoute = flip Router.push_ router
      debounce = delay (Milliseconds 200.0)

    { load } ← useRemoteDataDispatch (dispatch <<< UpdateSearchResult) \query -> debounce *> getSearchResult pursuitUrl query

    useEffect state.searchInput do
      if state.searchInput /= "" then load { searchQuery: state.searchInput } else pure unit
      mempty

    pure $ el NextUI.container { css: css { background: if isDark then "$theme2a" else "$codeLight", borderRadius: "0.5rem"} } $
      [ el NextUI.row {} $ R.h1' "Packages"
      , el NextUI.row {}
          [ el NextUI.input
              { initialValue: state.searchInput
              , clearable: true
              , bordered: true
              , contentLeft: icon_ tbSearch
              , placeholder: "Search"
              , "aria-label": "Search"
              , size: "lg"
              , type: "search"
              , fullWidth: true
              , onChange: handler targetValue (maybe (pure unit) (EditSearchField >>> dispatch))
              }
              React.empty
          , select { selected: buttonState, onSelect: setButtonState }
          ]
      , el NextUI.spacer { y: 1 } React.empty
      , el NextUI.row {} $ el NextUI.container { gap: 0, direction: "column" }
          $ renderSearchResults { isDark }
          $ state.searchResult <#> Array.filter (isVisible buttonState)

      ]

  where

  isVisible Select.All _ = true
  isVisible Select.Code { info: Declaration _ } = true
  isVisible Select.Code { info: Module _ } = true
  isVisible Select.Package { info: Package _ } = true
  isVisible _ _ = false

  renderSearchResult :: { isDark :: Boolean} -> SearchResult -> JSX
  renderSearchResult { isDark } { info: Declaration { "module": m, title, typeText: maybeTypeText, typeOrValue }, text, package } = React.fragment
    [ el NextUI.row {}
        [ el NextUI.card { css: css { background: "$overlay"} }
            [ el NextUI.cardHeader { css: css { paddingBottom: "0rem"}} [ renderDeclaration title ]
            , el NextUI.cardBody {}
                [ flip (maybe React.empty) maybeTypeText \typeText -> React.fragment
                    [ R.code {} typeText
                    , el NextUI.spacer { y: 1 } React.empty
                    ]
                , el Markdown.markdown { plugins: [ Markdown.gfm, Markdown.breaks ] } $ text
                ]
            , el NextUI.cardFooter { css: css { paddingTop: "0rem" }}
                [ renderPackage package
                , el NextUI.spacer { x: 1 } React.empty
                , renderModule m
                ]
            ]
        ]
    , el NextUI.spacer { y: 1 } React.empty
    ]

  renderSearchResult { isDark } p@{ info: Package { deprecated }, package, version } = React.fragment
    [ el NextUI.row {}
        [ el NextUI.card { css: css { background: "$overlay" } }
            [ el NextUI.cardHeader {} $
                  el NextUI.gridContainer {} [
                    el NextUI.grid { xs: 12 } $ renderPackage package
                  , if true then el NextUI.grid { xs: 12 } $ el NextUI.text {} "deprecated" else React.empty
                  ]
            , el NextUI.cardBody {}
              $ R.div { style: css { display: "flex", direction: "row"} }
                    [ DOM.text "Latest version: "
                    , el NextUI.link { href: "/packages/" <> package <> "/" <> version } $ version
                    ]
            -- , el NextUI.cardFooter {}
            --     [ renderPackage package
            --     , el NextUI.spacer { x: 1 } React.empty
            --     , renderModule m
            --     ]
            ]
        ]
    , el NextUI.spacer { y: 1 } React.empty
    ]
    where
    _ = spy "package" p
  renderSearchResult { isDark } { info: Module { "module": m }, package } = el NextUI.row {}
    [ el NextUI.col {} package
    , el NextUI.col {} $ m
    ]

  renderSearchResults :: { isDark :: Boolean } -> RD.RemoteData SearchError (Array SearchResult) -> Array JSX
  renderSearchResults _ (RD.Success []) = Array.singleton $ el NextUI.row {} $ el NextUI.text {} "No package found"
  renderSearchResults settings (RD.Success searchResults) = searchResults <#> renderSearchResult settings
  renderSearchResults _ (RD.Failure err) = Array.singleton $ el NextUI.row {} $ el NextUI.text { color: "error" } "Uh oh"
  renderSearchResults _ RD.Loading = Array.singleton $ el NextUI.row {} $ el NextUI.loading {} React.empty
  renderSearchResults _ RD.NotAsked = Array.singleton $ el NextUI.row {} $ el NextUI.text {} ""

  renderModule :: String -> JSX
  renderModule name = React.fragment [ icon_ tbBook2, el NextUI.text {} name ]

  renderPackage :: String -> JSX
  renderPackage package = React.fragment [ icon_ tbPackage, el NextUI.link { href: "/packages/" <> package, css: css { padding: "0.5rem" } } package ]

  renderDeclaration :: String -> JSX
  renderDeclaration name = React.fragment [ icon_ tbMathFunction, el NextUI.text { css: css { padding: "0.5rem" } } name ]

-- getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
-- getServerSideProps =
--   mkEffectFn1 $ fromAff
--     <<< map { props: _ }
--     <<< fetchData
