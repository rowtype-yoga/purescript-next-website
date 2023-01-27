module Pages.GettingStarted
  ( mkPage
  ) where

import Prelude

import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.String as Strings
import Debug (spy)
import Effect.Class.Console (log)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Simplified.ToJSX (el)
import React.Basic.Hooks (Component, component, empty) as React
import React.Basic.Hooks (JSX)
import React.Icons (icon)
import React.Icons.Si as SI
import React.Markdown as Markdown
import React.SyntaxHighlighter as SyntaxHighlighter
import Web.DOM (Element)

type Props =
  { header :: String
  }

mkHighlighter :: React.Component { node :: Element, inline :: Boolean, className :: Nullable String, children :: Array JSX }
mkHighlighter = do
  log "Init highlighter"
  -- SyntaxHighlighter.registerLanguage SyntaxHighlighter.syntaxHighlighter "haskell" SyntaxHighlighter.haskell
  React.component "Highlighter" \{ className, children } -> React.do
    let
      language = className # Nullable.toMaybe <#> Strings.stripPrefix (Strings.Pattern "language-") # Nullable.toNullable

    pure $ el SyntaxHighlighter.syntaxHighlighter { language, style: Nullable.notNull SyntaxHighlighter.docco, "PreTag": "div" } children

mkPage :: React.Component Props
mkPage = do
  highlighter <- mkHighlighter
  React.component "GettingStarted" \_props -> React.do
    pure $ el NextUI.container { gap: 0, lg: true } $
      [ el NextUI.row {} $ el NextUI.text { h1: true } "Getting Started"
      , el NextUI.row {} $ el NextUI.card { css: css { background: "$overlay" } } $ el NextUI.cardBody {}
          [ el NextUI.text { h2: true } "Installing PureScript"
          , el Markdown.markdown { remarkPlugins: [ Markdown.gfm, Markdown.breaks ], components: { code: highlighter } } $ gettingStartedText
          ]
      , el NextUI.spacer { y: 2 } React.empty
      , el NextUI.row {} $ el NextUI.card { css: css { background: "$overlay" } } $ el NextUI.cardBody {}
          [ el NextUI.text { h2: true } "Generating a new project"
          , el Markdown.markdown { remarkPlugins: [ Markdown.gfm, Markdown.breaks ], components: { code: highlighter } } $ generatingProjectText

          ]
      , el NextUI.spacer { y: 2 } React.empty
      , el NextUI.row {} $ el NextUI.card { css: css { background: "$overlay" } } $ el NextUI.cardBody {}
          [ el NextUI.text { h2: true } "Your first program"
          , el Markdown.markdown { remarkPlugins: [ Markdown.gfm, Markdown.breaks ], components: { code: highlighter } } $ firstProgramText

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
> 🍝
  ```
  """

firstProgramText ∷ String
firstProgramText =
  """  
  Open src/Main.purs to inspect your first Purescript program:
  ```purescript
module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

main :: Effect Unit
main = do
log "🍝"
  ```
  """
