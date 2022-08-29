module Pages.Error (mkError) where

import Prelude

import Components.Page as Page
import React.Basic.DOM as R

mkError :: String -> Page.Component Unit
mkError msg = do
  Page.component "Error" \_ _ -> pure render
  where
  render = R.h1_ [ R.text msg ]
