module React.Util where

import Prelude

import Data.Array (singleton)
import Prim.Row (class Lacks)
import React.Basic.DOM as R
import React.Basic.DOM.Simplified.ToJSX (class ToJSX, toJSX)
import React.Basic.Hooks (JSX, ReactComponent)
import React.Basic.Hooks as React
import Record as Record
import Type.Proxy (Proxy(..))

el
  ∷ ∀ props jsx
   . Lacks "children" props
  => ToJSX jsx
  ⇒ ReactComponent { children ∷ Array JSX | props }
  → Record props
  → jsx
  → JSX
el cmp props children =
  (React.element)
    cmp
    (Record.insert (Proxy ∷ Proxy "children") (toJSX children) props)
