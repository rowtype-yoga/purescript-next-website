module Pages.Package (mkPackage) where

import Prelude

import Components.Page as Page
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Semigroup.Foldable (intercalateMap)
import Next.Router (query, useRouter)
import NextUI.NextUI as NextUI
import React.Basic.DOM (h1_, text) as R
import React.Basic.Hooks as React
import React.Util (el)
import Yoga.JSON as JSON
import Yoga.JSON.Error (renderHumanError)

type Props = {}

type X =
  { packageName :: String
  -- TODO: Deal with `undefined` as `Maybe` conversion
  , packageVersion :: Maybe String
  }

mkPackage :: Page.Component Props
mkPackage =
  Page.component "Package" \_env _props -> React.do
    router <- useRouter
    let myForeign = JSON.read $ query router
    case myForeign of
      Left errs -> pure $ R.text ("Errors: this should never happen. "
        <> intercalateMap "," renderHumanError errs)
      Right (x::X) -> pure $ el NextUI.container {} $
        [ el NextUI.row {} $ R.h1_ [ R.text "Package" ]
        , el NextUI.row {} $ R.text $ "Name: " <> x.packageName
        , el NextUI.row {} $ R.text $ "Version: " <> (x.packageVersion # fromMaybe "latest")
        ]
