module Components.Select
  ( Option(..)
  , mkSelect
  ) where

import Prelude

import Components.Page as Page
import Data.Array as Array
import Data.Eq.Generic (genericEq)
import Data.Generic.Rep (class Generic)
import Data.Maybe (maybe)
import Debug (spy)
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
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

foreign import data Set :: Type -> Type
foreign import toArray :: Set String -> Array String

foreign import new_ :: forall item. item -> Set item

fromKey :: String -> Option
fromKey "Code" = Code
fromKey "Package" = Package
fromKey _ = All

mkSelect :: Page.Component Props
mkSelect =
  Page.component "Select" \_ { selected, onSelect } -> React.do
    pure
      $ el NextUI.container { justify: "flex-start" }
      $ el NextUI.dropdown { solid: true }
          [ el NextUI.dropdownButton { color: "secondary" } $ renderOption selected
          , el NextUI.dropdownMenu
              { disallowEmptySelection: true
              , color: "secondary"
              , variant: "solid"
              , selectionMode: "single"
              , selectedKeys: new_ $ renderOption selected
              , onSelectionChange: mkEffectFn1 $ toArray >>> Array.head >>> maybe All fromKey >>> onSelect
              } $ [ All, Code, Package ] <#> option
          ]

  where
  option opt =
    el NextUI.dropdownItem { key: renderOption opt }
      $ el NextUI.text {}
      $ renderOption opt
