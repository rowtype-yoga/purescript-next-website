module Pages.Page
  ( mkPage
  ) where

import Prelude

import Next.Router as Router
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Simplified.Generated as R
import React.Basic.DOM.Simplified.ToJSX (el)
import React.Basic.Hooks as React
import React.Icons (icon)
import React.Icons.Si (siPurescript)

type Props =
  { header :: String
  }

mkPage :: React.Component Props
mkPage = do
  React.component "Home" \props ->
    React.do
      { theme, isDark } <- NextUI.useTheme
      router <- Router.useRouter
      let
        dispatchRoute = flip Router.push_ router
      pure $ el NextUI.container { gap: 0, lg: true, css: css { display: "flex", alignItems: "center", height: "calc(100vh - 100px)" } }
        [ el NextUI.card
            { css: css { background: "$overlay", position: "relative", marginBottom: "50px" }
            }
            [ el NextUI.cardBody {}
                $ el NextUI.container { display: "flex", justify: "space-evenly" }
                    [ R.div {} $ el NextUI.container { display: "flex", direction: "column" }
                        [ R.div { style: css { display: "flex", alignItems: "center" } }
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
                        , R.div {} $ el NextUI.text { h2: true, size: "$2xl", weight: "normal" } "A clean and elegant functional programming language"
                        ]
                    , R.div { style: css { display: "flex", alignItems: "center" } }
                        $ R.div {}
                        $ el NextUI.button { shadow: false, css: css { minHeight: "5rem", padding: "3rem", background: if isDark then "$theme4" else "$theme1" }, onClick: dispatchRoute "/getting-started" }
                        $ el NextUI.text { size: "$3xl", color: "white", css: css { fontWeight: "$bold" } } "Get started"
                    ]
            ]
        ]

