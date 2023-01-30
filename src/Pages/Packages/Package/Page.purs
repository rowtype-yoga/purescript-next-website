module Pages.Packages.Package (mkPage) where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe, fromMaybe)
import Data.Semigroup.Foldable (intercalateMap)
import Next.Router (query, useRouter)
import NextUI.NextUI as NextUI
import React.Basic.DOM (h1_, text) as R
import React.Basic.DOM.Simplified.ToJSX (el)
import React.Basic.Hooks as React
import Yoga.JSON as JSON
import Yoga.JSON.Error (renderHumanError)

type Props = {}

type Package =
  { packageName :: String
  , packageVersion :: Maybe String
  }

mkPage :: React.Component Props
mkPage =
  React.component "Package" \_props -> React.do
    router <- useRouter
    let myForeign = JSON.read $ query router
    case myForeign of
      Left errs -> pure $ R.text
        ( "Errors: this should never happen. "
            <> intercalateMap "," renderHumanError errs
        )
      Right (package :: Package) -> pure $ el NextUI.container {} $
        [ el NextUI.row {} $ R.h1_ [ R.text "Package" ]
        , el NextUI.row {} $ R.text $ "Name: " <> package.packageName
        , el NextUI.row {} $ R.text $ "Version: " <> (package.packageVersion # fromMaybe "latest")
        ]
