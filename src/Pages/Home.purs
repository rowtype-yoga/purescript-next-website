module Pages.Home (mkHome, getServerSideProps) where

import Prelude

import Components.Page as Page
import Control.Promise (Promise, fromAff)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Simplified.Generated as R
import React.Util (el)

type Props =
  { header :: String
  }

mkHome :: Page.Component Props
mkHome = do
  Page.component "Home" \env props -> React.do
    pure $ el NextUI.container { fluid: true, css: css { height: "100%" } }
      $ el NextUI.row { justify: "center", align: "center", css: css { height: "100%" } }
          [ R.div {} $ el NextUI.text
              { h1: true
              , size: 60
              }
              "Purescript "

          ]

fetchData :: forall ctx. ctx -> Aff Props
fetchData _ = do
  pure { header: "Home" }

getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
getServerSideProps =
  mkEffectFn1 $ fromAff
    <<< map { props: _ }
    <<< fetchData
