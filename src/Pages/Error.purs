module Pages.Error (mkError) where

import Prelude

import React.Basic.DOM as R
import React.Basic.Hooks as React

mkError :: String -> React.Component Unit
mkError msg = do
  React.component "Error" \_ -> pure render
  where
  render = R.h1_ [ R.text msg ]
