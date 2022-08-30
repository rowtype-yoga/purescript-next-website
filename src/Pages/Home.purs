module Pages.Home (mkHome, getServerSideProps) where

import Prelude

import Components.Page as Page
import Control.Promise (Promise, fromAff)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Next.Router as Router
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.Hooks as React
import React.Icons (icon)
import React.Icons.Si (siPurescript)
import React.Util (el)

type Props =
  { header :: String
  }

mkHome :: Page.Component Props
mkHome = do
  Page.component "Home" \env props ->
    React.do
      { theme } <- NextUI.useTheme
      router <- Router.useRouter
      let
        dispatchRoute = Router.push router
      pure $ el NextUI.container { fluid: true, css: css {  } }
        $ el NextUI.card
            { css: css { height: "100%", background: "$transparentBackground" }
            }
            [ el NextUI.cardBody {}
                $ el NextUI.container {}
                $ el NextUI.row { css: css { height: "100%" } }
                    [ el NextUI.col {  }
                        [ el NextUI.row {}
                            [ icon siPurescript { style: css { color: "$primarySolidContrast", minWidth: "5rem" }, size: "5rem" }
                            , el NextUI.spacer {} React.empty
                            , el NextUI.text
                                { h1: true
                                }
                                "PureScript "
                            ]
                        , el NextUI.row {} $ el NextUI.text { size: "$xl" } "A fast, powerful functional language"
                        ]
                    , el NextUI.col { align: "center", content: "center", css: css { height: "100%"}} 
                        $ el NextUI.button { shadow: false, color: "primary", css: css { minHeight: "5rem", minWidth: "50%" }, onClick: dispatchRoute "/getting-started" }
                        $ el NextUI.text { size: "$3xl", color: "secondary", css: css { fontWeight: "$bold" } } "Get started"
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
