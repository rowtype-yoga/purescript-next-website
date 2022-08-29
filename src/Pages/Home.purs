module Pages.Home (mkHome, getServerSideProps) where

import Prelude

import Components.Page as Page
import Control.Promise (Promise, fromAff)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Icons (icon)
import React.Icons.Si (siPurescript)
import React.Util (el)
import Themes (getColorValue)
import React.Basic.Hooks as React

type Props =
  { header :: String
  }

mkHome :: Page.Component Props
mkHome = do
  Page.component "Home" \env props -> React.do
    { theme } <- NextUI.useTheme
    pure $ el NextUI.container { fluid: true, css: css { height: "100%" } }
      $ el NextUI.row { justify: "center", align: "center", css: css { height: "100%" } }
          [ icon siPurescript { style: css { color: getColorValue theme "primarySolidContrast", minWidth: "5rem" }, size: "5rem" }
          , el NextUI.spacer {} React.empty
          , el NextUI.text
              { h1: true
              , size: "4rem"
              }
              "PureScript "
          ]

fetchData :: forall ctx. ctx -> Aff Props
fetchData _ = do
  pure { header: "Home" }

getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
getServerSideProps =
  mkEffectFn1 $ fromAff
    <<< map { props: _ }
    <<< fetchData
