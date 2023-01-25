module Pages.Head
  ( mkHead
  )
  where

import Prelude

import React.Basic.DOM as RD
import React.Basic.DOM.Simplified.Generated as R
import React.Basic.Hooks as React

mkHead :: React.Component {}
mkHead = do
  pure $ \_props -> React.fragment
    [ R.title {} "Purescript"
    , RD.meta { content: "width=device-width, initial-scale=1", name: "viewport" }
    , RD.meta { name: "description", content: "PureScript - An elegant functional language for the web" }
    ]
