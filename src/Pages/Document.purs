module Pages.Document (mkDocument) where

import Prelude

import Next.Document as N
import React.Basic.DOM as R
import React.Basic.Hooks as React

mkDocument :: forall props. React.Component props
mkDocument = React.component "Document" \_ -> do

  pure $ render
  where
  render =
    N.html
      { children:
          [ N.head
              { children:
                  [ R.title_ [ R.text "Purescript - A functional programming language for the web" ]
                  , R.link { rel: "icon", href: "data:;base64,iVBORw0KGgo=" }
                  ]
              }
          , R.body
              { className: "font-sans antialiased leading-normal tracking-wider bg-slate-200"
              , children:
                  [ N.main {}
                  , N.nextScript {}
                  ]
              }
          ]
      }
