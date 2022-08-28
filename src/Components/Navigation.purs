module Components.Navigation (navigation) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Traversable (traverse_)
import Data.Tuple.Nested ((/\))
import Debug (spy)
import Next.Router (useRouter)
import Next.Router as Router
import NextUI.NextUI (switch, useTheme)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Events (targetChecked)
import React.Basic.Events (handler)
import React.Basic.Hooks (Component, component, useEffect, useState')
import React.Basic.Hooks as React
import React.Icons (icon)
import React.Icons.Si (siDiscord, siDiscourse, siGithub, siPurescript)
import React.Util (el)
import Themes (getColorValue)
import Web.DOM.Document (documentElement)
import Web.DOM.Element as DOMEL
import Web.HTML (window)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.Window (document)

navigation :: Component Unit
navigation = component "Navbar" \_props -> React.do

  { theme } <- useTheme
  router <- useRouter
  let
    dispatchRoute = Router.push router
  isDark /\ setDark <- useState' false
  _ <- useEffect [ isDark ] do
    w <- window
    maybeElem <- document w <#> toDocument >>= documentElement
    case maybeElem of
      Just el -> do
        (DOMEL.setAttribute "class" if isDark then "light-theme" else "dark-theme") el
        pure mempty
      Nothing -> pure mempty
  pure $ el NextUI.navbar { isBordered: isDark, variant: "static" }
    [ el NextUI.navbarBrand {}
        $ el NextUI.link
            { onClick: dispatchRoute $ "/"
            }
        $ icon siPurescript { style: css { color: getColorValue theme "neutral" }, size: "3rem" }
    , el NextUI.navbarContent { hideIn: "xs" } $ map (mkLink theme)
        [ { onClick: dispatchRoute "/pursuit", title: "Getting started" }
        , { onClick: dispatchRoute "/pursuit", title: "Try Purescript" }
        , { onClick: dispatchRoute "/pursuit", title: "Pursuit" }
        ]
    , el NextUI.navbarContent {}
        [ el NextUI.navbarLink
            { href: "https://purescript.org/chat"
            }
            $ icon siDiscord { style: css { color: spy "color value" $ getColorValue theme "neutral" }, size: "1.5rem" }
        , el NextUI.navbarLink
            { href: "https://discourse.purescript.org/"
            , target: "_blank"
            }
            $ icon siDiscourse { style: css { color: spy "color value" $ getColorValue theme "neutral" }, size: "1.5rem" }
        , el NextUI.navbarLink
            { href: "https://www.github.com/purescript/purescript"
            , target: "_blank"
            }
            $ icon siGithub { style: css { color: spy "color value" $ getColorValue theme "neutral" }, size: "1.5rem" }
        , el switch { checked: isDark, onChange: handler targetChecked $ traverse_ setDark } ""
        ]
    ]
  where
  mkLink theme { onClick, title } =
    el NextUI.navbarLink
      { onClick
      }
      $ el NextUI.text { size: "$xl", color: getColorValue theme "neutral" } title
