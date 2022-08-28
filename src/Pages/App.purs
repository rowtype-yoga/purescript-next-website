module Pages.App (mkApp) where

import Prelude

import Components.Loading (mkLoading)
import Components.Navigation (navigation)
import Components.Page (Component)
import Context.Settings (mkSettingsProvider)
import Control.Monad.Reader (runReaderT)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import NextUI.NextUI (nextThemesProvider, nextUIProvider)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.Hooks as React
import React.Util (el)
import Themes as Themes
import Unsafe.Coerce (unsafeCoerce)

type AppProps props =
  { "Component" :: Component props
  , pageProps :: props
  }

backgroundImage isDark =
  if isDark then
    """
      radial-gradient(45rem 45rem at left 70rem top 40rem, rgba(0, 0, 139, 0.75) 0% 10%, #0000 70% 80%),
      radial-gradient(20rem 20rem at left 15rem top 20rem, rgba(30, 144, 255,0.5) 0% 10%,#0000 90% 90%);
      """
  else
    """
      radial-gradient(65rem 65rem at left 70rem top 40rem, rgba(0, 0, 139, 0.75) 0% 10%,#0000 70% 80%),
      radial-gradient(20rem 20rem at left 15rem top 20rem, rgba(0, 191, 255, 0.25) 0% 10%,#0000 90% 90%)
      """

mkApp :: forall props. Effect (EffectFn1 (AppProps props) React.JSX)
mkApp = do
  context /\ settingsProvider <- mkSettingsProvider
  loading <- mkLoading
  pure
    $ mkEffectFn1 \props ->
        do
          component <- runReaderT props."Component" { settings: context }
          nav <- navigation
          dark <- Themes.mkDark
          light <- Themes.mkLight
          pure
            $ settingsProvider
            $ el nextThemesProvider
                { defaultTheme: "system"
                , attribute: "class"
                , value: { dark: (unsafeCoerce dark).className, light: (unsafeCoerce light).className }
                }
            $ el nextUIProvider {}
                [ loading unit
                , nav unit
                , el NextUI.container { css: css { height: "80vh" } } $ component props.pageProps
                ]
