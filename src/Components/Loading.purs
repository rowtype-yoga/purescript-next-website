module Components.Loading (mkLoading) where

import Prelude

import Data.Monoid (guard)
import Data.Tuple.Nested ((/\))
import Next.Router (onRouteChangeStart, routeChangeComplete, routeChangeError)
import NextUI.NextUI as NextUI
import React.Basic.Hooks as React
import React.Util (el)

mkLoading :: React.Component Unit
mkLoading =
  React.component "Loading" \_ -> React.do
    isLoading /\ setIsLoading <- React.useState' false
    React.useEffectOnce do
      onRouteChangeStart \_ -> setIsLoading true
    React.useEffectOnce do
      routeChangeComplete \_ -> setIsLoading false
    React.useEffectOnce do
      routeChangeError \_ -> setIsLoading false
    pure
      $ el NextUI.container { justify: "flex-start" }
      $ guard isLoading
      $ el NextUI.loading {} React.empty

