module Pages.GettingStarted
  (
    -- getServerSideProps
    -- , 
    mkGettingStarted
  ) where

import Prelude

import Components.Page as Page
import NextUI.NextUI as NextUI
import React.Basic.DOM.Simplified.Generated as R
import React.Util (el)

type Props =
  { header :: String
  }


mkGettingStarted :: Page.Component Props
mkGettingStarted = do

  Page.component "GettingStarted" \env props -> React.do
    pure $ el NextUI.container { gap: 0, lg: true} $
      [ el NextUI.row {} $ R.h1' "Getting Started"
      ]

-- getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
-- getServerSideProps =
--   mkEffectFn1 $ fromAff
--     <<< map { props: _ }
--     <<< fetchData
