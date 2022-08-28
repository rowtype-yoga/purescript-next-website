module Pages.Pursuit
  (
    -- getServerSideProps
    -- , 
    mkPursuit
  ) where

import Prelude

import Components.Page as Page
import Control.Monad.Except (except)
import Data.Either (Either(..))
import Data.Eq.Generic (genericEq)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Data.Show.Generic (genericShow)
import Data.Tuple.Nested ((/\))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)
import Effect.Exception (Error)
import Fetch (Method(..), fetch)
import Fetch.Yoga.Json (fromJSON)
import Foreign (ForeignError(..))
import Network.RemoteData (RemoteData)
import Network.RemoteData as RD
import Next.Router (query, useRouter)
import Next.Router as Router
import NextUI.NextUI as NextUI
import React.Basic.DOM.Simplified.Generated as R
import React.Basic.Hooks (type (/\), mkReducer, useEffect)
import React.Basic.Hooks as React
import React.Hooks.UseRemoteData (useRemoteDataDispatch)
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

data SearchInfo = Declaration { | DeclarationR } | Package { | PackageR }

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

data Action = UpdateSearchResult (RemoteData SearchError (Array SearchResult))

type State =
  { searchResult ∷ RemoteData SearchError (Array SearchResult)
  }

defaultState :: State
defaultState = { searchResult: RD.NotAsked }

reduce ∷ State → Action → State
reduce s (UpdateSearchResult searchResult) =
  s { searchResult = searchResult }

getSearchResult :: {} -> Aff (Either SearchError (Array SearchResult))
getSearchResult {} = do
  let url = "http://localhost:3000/search?q=barlow"
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

mkPursuit :: Page.Component Props
mkPursuit = do

  reducer ← mkReducer reduce # liftEffect
  Page.component "Pursuit" \env props -> React.do
    router <- useRouter
    let
      q :: { q :: String }
      q = query router

      dispatchRoute = Router.push router

    state /\ dispatch ← React.useReducer defaultState reducer

    remoteSearchResult ← useRemoteDataDispatch (dispatch <<< UpdateSearchResult) getSearchResult

    useEffect unit do
      remoteSearchResult.load {}
      mempty
    -- http://localhost:3000/search\?q
    pure $ el NextUI.container {} $
      [ el NextUI.row {}
          [ R.h1' "Pursuit"
          , el NextUI.text {} $ show state.searchResult 
          ]
      ]

-- getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
-- getServerSideProps =
--   mkEffectFn1 $ fromAff
--     <<< map { props: _ }
--     <<< fetchData
