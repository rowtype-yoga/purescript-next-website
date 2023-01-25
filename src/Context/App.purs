module Context.App
  ( Context
  , ContextContent
  , context
  , defaultContextContent
  )
  where

import Prelude

import Effect.Unsafe (unsafePerformEffect)
import React.Basic as React

type ContextContent =
  { pursuitUrl :: String
  }

type Context = React.ReactContext ContextContent

foreign import pursuitUrl :: String

defaultContextContent ∷ ContextContent
defaultContextContent =
  { pursuitUrl
  }

context :: Context
context = unsafePerformEffect $ do
  React.createContext defaultContextContent
