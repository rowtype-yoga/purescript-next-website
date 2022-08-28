module Pages.Pursuit
  (
    -- getServerSideProps
    -- , 
    mkPursuit
  ) where

import Prelude

import Components.Page as Page
import NextUI.NextUI as NextUI
import Next.Router (query, useRouter)
import Next.Router as Router
import React.Basic.DOM.Simplified.Generated as R
import React.Basic.Hooks as React
import React.Util (el)

type Props =
  { header :: String
  }


mkPursuit :: Page.Component Props
mkPursuit = do

  Page.component "Pursuit" \env props -> React.do
    router <- useRouter
    let
      q :: { q :: String }
      q = query router

      dispatchRoute = Router.push router

    pure $ el NextUI.container {} $
      [ el NextUI.row {}
          [ R.h1' "Pursuit"

          ]
      ]

-- getServerSideProps :: forall ctx. EffectFn1 ctx (Promise { props :: Props })
-- getServerSideProps =
--   mkEffectFn1 $ fromAff
--     <<< map { props: _ }
--     <<< fetchData
