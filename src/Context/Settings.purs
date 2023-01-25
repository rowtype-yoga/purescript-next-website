module Context.Settings where

import Prelude

import Context.App as ContextApp
import Effect (Effect)
import React.Basic.Hooks as React


mkSettingsProvider :: Effect (React.JSX -> React.JSX)
mkSettingsProvider = do
  React.component "SettingsProvider" \content -> React.do
    pure $ React.provider ContextApp.context (ContextApp.defaultContextContent) $ pure content

