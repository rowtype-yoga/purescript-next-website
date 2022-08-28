module Pages.Packages
  (
    -- getServerSideProps
    -- , 
    mkPackages
  ) where

import Prelude

import Components.Page as Page
import Control.Monad.Except (except)
import Data.Array as Array
import Data.Either (Either(..))
import Data.Eq ((/=))
import Data.Eq.Generic (genericEq)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe, maybe)
import Data.Show.Generic (genericShow)
import Data.Tuple.Nested ((/\))
import Debug (spy)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception (Error)
import Fetch (Method(..), fetch)
import Fetch.Yoga.Json (fromJSON)
import Foreign (ForeignError(..))
import JSURI (encodeURIComponent)
import Network.RemoteData (RemoteData)
import Network.RemoteData as RD
import Next.Router (query, useRouter)
import Next.Router as Router
import NextUI.NextUI as NextUI
import React.Basic.DOM.Events (targetValue)
import React.Basic.DOM.Simplified.Generated as R
import React.Basic.Events (handler)
import React.Basic.Hooks (type (/\), JSX, mkReducer, useEffect)
import React.Basic.Hooks as React
import React.Hooks.UseRemoteData (useRemoteDataDispatch)
import React.Icons (icon_)
import React.Icons.Tb (tbSearch)
import React.Util (el)
import Yoga.JSON (class ReadForeign)
import Yoga.JSON as YogaJson

type Props =
  { header :: String
  }

type DeclarationR =
  ( module :: String
  , title :: String
  , typeOrValue :: String
  , typeText :: Maybe String
  )

type PackageR = (deprecated :: Boolean)

type ModuleR = (module :: String )

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
  , url :: String
  , version :: String
  }

data SearchError = SearchError

derive instance Generic SearchError _
instance Eq SearchError where
  eq = genericEq

instance Show SearchError where
  show SearchError = "Failed to get search results"

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

getSearchResult :: { searchQuery :: String } -> Aff (Either SearchError (Array SearchResult))
getSearchResult { searchQuery } = do
  let url = "http://localhost:3000/search?q=" <> (maybe searchQuery identity $ encodeURIComponent searchQuery)
  { status, text, json } ← fetch url
    { method: GET
    , headers: { "Accept": "application/json" }
    }
  case status of
    200 -> do
      searchResult :: Array SearchResult <- fromJSON json
      pure $ Right searchResult
    statusCode -> do
      body <- text
      log $ "Got invalid response [" <> (show statusCode) <> "]:\n" <> body
      pure $ Left SearchError

mkPackages :: Page.Component Props
mkPackages = do

  reducer ← mkReducer reduce # liftEffect
  Page.component "Pursuit" \env props -> React.do
    router <- useRouter
    let
      q :: { q :: String }
      q = query router

      dispatchRoute = Router.push router

    state /\ dispatch ← React.useReducer defaultState reducer

    remoteSearchResult ← useRemoteDataDispatch (dispatch <<< UpdateSearchResult) getSearchResult

    useEffect state.searchInput do
      if state.searchInput /= "" then remoteSearchResult.load { searchQuery: state.searchInput } else pure unit
      mempty
    -- http://localhost:3000/search\?q
    pure $ el NextUI.container {} $
      [ el NextUI.row {} $ R.h1' "Packages"
      , el NextUI.row {} $ el NextUI.input
          { initialValue: spy "searchInput" state.searchInput
          , clearable: true
          , bordered: true
          , contentLeft: icon_ tbSearch
          , placeholder: "Search"
          , size: "xl"
          , type: "search"
          , width: "600px"
          , onChange: handler targetValue (maybe (pure unit) (EditSearchField >>> dispatch))
          }
          React.empty
      , el NextUI.row {} $ el NextUI.container {} $
          renderSearchResults state.searchResult

      ]

  where
  renderSearchResult :: SearchResult -> JSX
  renderSearchResult { info: Declaration { "module": m, title }, package } = el NextUI.row {} [
     el NextUI.col {} m
    , el NextUI.col {} title
  ]
  renderSearchResult { info: Package { deprecated }, package } = el NextUI.row {} [
     el NextUI.col {} package
    , el NextUI.col {} $ if deprecated then "deprecated" else ""
  ]
  renderSearchResult { info: Module { "module": m }, package } = el NextUI.row {} [
     el NextUI.col {} package
    , el NextUI.col {} $ m
  ]

  renderSearchResults :: RD.RemoteData SearchError (Array SearchResult) -> Array JSX
  renderSearchResults (RD.Success searchResults) = searchResults <#> renderSearchResult
  renderSearchResults (RD.Failure err) = Array.singleton $ el NextUI.row {} $ el NextUI.text {} "Uh oh"
  renderSearchResults RD.Loading = Array.singleton $ el NextUI.row {} $ el NextUI.loading {} React.empty
  renderSearchResults RD.NotAsked = Array.singleton $ el NextUI.row {} $ el NextUI.text {} ""
-- getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
-- getServerSideProps =
--   mkEffectFn1 $ fromAff
--     <<< map { props: _ }
--     <<< fetchData
