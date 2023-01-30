module React.SyntaxHighlighter
  ( Language
  , Style
  , docco
  , haskell
  , registerLanguage
  , syntaxHighlighter
  )
  where

import Prelude

import Data.Function.Uncurried (Fn2, runFn2)
import Data.Nullable (Nullable)
import Effect (Effect)
import React.Basic (ReactComponent)

foreign import data Style :: Type

foreign import syntaxHighlighter :: forall props. ReactComponent {  style :: Nullable Style| props }

foreign import docco :: Style

foreign import data Language :: Type

foreign import haskell :: Language

foreign import registerLanguageImpl :: forall props. ReactComponent {  style :: Nullable Style| props } -> Fn2 String Language (Effect Unit) 

registerLanguage ∷ ∀ (props9 ∷ Row Type). ReactComponent { style ∷ Nullable Style | props9 } → String → Language → Effect Unit
registerLanguage highlighter = runFn2 (registerLanguageImpl highlighter)
