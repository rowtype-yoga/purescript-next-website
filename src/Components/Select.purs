module Components.Select
  ( Option(..)
  , mkSelect
  ) where

import Prelude

import Components.Page as Page
import Data.Eq.Generic (genericEq)
import Data.Generic.Rep (class Generic)
import Effect (Effect)
import NextUI.NextUI as NextUI
import React.Basic.Events (handler_)
import React.Util (el)

type Props =
  { selected :: Option
  , onSelect :: Option -> Effect Unit
  }

data Option = All | Code | Package
derive instance Generic Option _
instance Eq Option where
  eq = genericEq

renderOption ∷ Option → String
renderOption All = "All"
renderOption Code = "Code"
renderOption Package = "Package"

mkSelect :: Page.Component Props
mkSelect =
  Page.component "Select" \_ { selected, onSelect } -> React.do
    pure
      $ el NextUI.container { justify: "flex-start" }
      $ el NextUI.buttonGroup { ghost: true }
      $ [ All, Code, Package ] <#> option onSelect selected

  where
  option onSelect selected msg =
    el NextUI.button { onClick: handler_ $ onSelect msg }
      $ el NextUI.text { weight: if selected == msg then "extrabold" else "normal" }
      $ renderOption msg
