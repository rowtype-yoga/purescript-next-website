module Pages.GettingStarted
  ( mkPage
  ) where

import Prelude

import Markdown.Markdown as Markdown
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Simplified.ToJSX (el)
import React.Basic.Hooks (Component, component, empty) as React
import React.Icons (icon)
import React.Icons.Si as SI

type Props =
  { header :: String
  }

mkPage :: React.Component Props
mkPage = do

  React.component "GettingStarted" \_props -> React.do
    pure $ el NextUI.container { gap: 0, lg: true } $
      [ el NextUI.row {} $ el NextUI.text { h1: true } "Getting Started"
      , el NextUI.row {} $ el NextUI.card { css: css { background: "$overlay" } } $ el NextUI.cardBody {}
          [ el NextUI.text { h2: true } "Installing PureScript"
          , el Markdown.markdown { plugins: [ Markdown.gfm, Markdown.breaks ] } $ gettingStartedText
          ]
      , el NextUI.spacer { y: 2 } React.empty
      , el NextUI.row {} $ el NextUI.card { css: css { background: "$overlay" } } $ el NextUI.cardBody {}
          [ el NextUI.text { h2: true } "Generating a new project"
          , el Markdown.markdown { plugins: [ Markdown.gfm, Markdown.breaks ] } $ generatingProjectText

          ]
      , el NextUI.spacer { y: 2 } React.empty
      , el NextUI.row {} $ el NextUI.card { css: css { background: "$overlay" } } $ el NextUI.cardBody {}
          [ el NextUI.row {} $ el NextUI.text { h2: true } "IDE support"
          , el NextUI.row {} $ el NextUI.text {} "PureScript support is available in the following editors:"
          , el NextUI.spacer { y: 1 } React.empty
          , el NextUI.row {}
              [ el NextUI.link { href: "https://marketplace.visualstudio.com/items?itemName=nwolverson.ide-purescript" } $ icon SI.siVisualstudio { style: css { fontSize: "3rem" } }
              , el NextUI.spacer { x: 1 } React.empty
              , el NextUI.link { href: "https://plugins.jetbrains.com/plugin/9738-purescript" } $ icon SI.siIntellijidea { style: css { fontSize: "3rem" } }
              , el NextUI.spacer { x: 1 } React.empty
              , el NextUI.link { href: "https://github.com/purescript-contrib/purescript-vim" } $ icon SI.siVim { style: css { fontSize: "3rem" } }
              , el NextUI.spacer { x: 1 } React.empty
              , el NextUI.link { href: "https://github.com/purescript-emacs/purescript-mode" } $ icon SI.siGnuemacs { style: css { fontSize: "3rem" } }
              ]
          ]
      , el NextUI.spacer { y: 5 } React.empty
      ]

gettingStartedText ∷ String
gettingStartedText =
  """  
  The easiest way to install purescript is via [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
  ```bash
  npm install -g purescript spago
  ```
  """

generatingProjectText ∷ String
generatingProjectText =
  """  
  Initialise a new project:
  ```bash
  npm init -y
  spago init
  ```

  Run your project:
  ```bash
  spago run
  # 🍝
  ```
  """

