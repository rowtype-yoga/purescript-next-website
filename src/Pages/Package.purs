module Pages.Package (mkPackage) where

import Prelude

import Components.Page as Page
import Next.Router (query, useRouter)
import NextUI.NextUI as NextUI
import React.Basic.DOM (h1_, text) as R
import React.Basic.Hooks as React
import React.Util (el)

type Props = {}

type X =
  { packageName :: String
  -- TODO: Deal with `undefined` as `Maybe` conversion
  , packageVersion :: String
  }

mkPackage :: Page.Component Props
mkPackage =
  Page.component "Package" \_env _props -> React.do
    router <- useRouter
    let ({ packageName, packageVersion }) = query router
    pure $ el NextUI.container {} $
      [ el NextUI.row {} $ R.h1_ [ R.text "Package" ]
      , el NextUI.row {} $ R.text $ "Name: " <> packageName
      , el NextUI.row {} $ R.text $ "Version: " <> packageVersion
      ]
