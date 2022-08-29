module Pages.Try
  (
    -- getServerSideProps
    -- , 
    mkTry
  ) where

import Prelude

import Components.Page as Page
import NextUI.NextUI as NextUI
import React.Basic.DOM.Simplified.Generated as R
import React.Util (el)

type Props =
  { header :: String
  }


mkTry :: Page.Component Props
mkTry = do

  Page.component "Try Purescript" \env props -> React.do
    pure $ el NextUI.container {} $
      [ el NextUI.row {} $ R.h1' "Getting Started"
      ]

-- getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
-- getServerSideProps =
--   mkEffectFn1 $ fromAff
--     <<< map { props: _ }
--     <<< fetchData
