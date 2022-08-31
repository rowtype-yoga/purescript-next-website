module Markdown.Markdown where

import Prelude
import React.Basic.Hooks (ReactComponent)

foreign import data Plugin :: Type

foreign import breaks :: Plugin
foreign import gfm :: Plugin

foreign import markdown :: forall props. ReactComponent { plugins :: Array Plugin | props }
