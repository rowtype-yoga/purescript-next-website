module Pages.Layout
  ( mkRootLayout
  ) where

import Prelude

import Components.Navigation as Navigation
import Context.Settings (mkSettingsProvider)
import NextUI.NextUI (nextThemesProvider, nextUIProvider)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Simplified.ToJSX (el)
import React.Basic.Hooks as React
import Themes as Themes
import Unsafe.Coerce (unsafeCoerce)

mkRootLayout :: React.Component { children :: Array React.JSX }
mkRootLayout = do
  settingsProvider <- mkSettingsProvider
  nav <- Navigation.navigation
  dark <- Themes.mkDark
  light <- Themes.mkLight
  React.component "RootLayout" \{ children } -> React.do
    pure
      $ settingsProvider
      $ el nextThemesProvider
          { defaultTheme: "system"
          , attribute: "class"
          , storageKey: "theme"
          , value: { dark: (unsafeCoerce dark).className, light: (unsafeCoerce light).className }
          }
      $ el nextUIProvider {}
          [ nav unit
          , el NextUI.spacer { y: 1 } React.empty
          , el NextUI.container { css: css { minHeight: "calc(100% - 100px)" } } children
          ]
