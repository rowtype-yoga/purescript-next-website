module Pages.Home (mkHome, getServerSideProps) where

import Prelude

import Components.Page as Page
import Control.Promise (Promise, fromAff)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Next.Router as Router
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Simplified.Generated as R
import React.Basic.Hooks as React
import React.Icons (icon)
import React.Icons.Si (siPurescript)
import React.Util (el)
import Themes (getColorValue)

type Props =
  { header :: String
  }

mkHome :: Page.Component Props
mkHome = do
  Page.component "Home" \env props ->
    React.do
      { theme, isDark } <- NextUI.useTheme
      router <- Router.useRouter
      let
        dispatchRoute = Router.push router
      pure $ el NextUI.container { display: "flex", css: css { minHeight: "70vh" }, alignItems: "center" }
        $ el NextUI.card
            { css: css { height: "100%", background: "$overlay", position: "relative", top: "50%" }
            }
            [ el NextUI.cardBody {}
                $ el NextUI.container { display: "flex", justify: "space-evenly"}
                    [ R.div {} $ el NextUI.container { display: "flex", direction:"column" }
                        [ R.div { style: css {display: "flex", alignItems: "center" } } 
                            [ icon siPurescript { style: css { color: "primary", strokeWidth: "0.5", fontSize: "6rem" } }
                            , el NextUI.spacer {} React.empty
                            , el NextUI.text
                                { h1: true
                                , css: { letterSpacing: "0.002em" }
                                , size: "$7xl"
                                , weight: "black"
                                }
                                "PureScript "
                            ]
                        , R.div {} $ el NextUI.text { h2: true, size: "$2xl", weight: "normal" } "A fast and elegant functional programming language"
                        ]
                    , R.div { style: css { display: "flex", alignItems: "center"} }
                        $ R.div {}
                        $ el NextUI.button { shadow: false, css: css { minHeight: "5rem", padding: "3rem", background: if isDark then "$theme4" else "$theme1"}, onClick: dispatchRoute "/getting-started" }
                        $ el NextUI.text { size: "$3xl", color: "white", css: css { fontWeight: "$bold"} } "Get started"
                    ]
            ]

fetchData :: forall ctx. ctx -> Aff Props
fetchData _ = do
  pure { header: "Home" }

getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
getServerSideProps =
  mkEffectFn1 $ fromAff
    <<< map { props: _ }
    <<< fetchData
