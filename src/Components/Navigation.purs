module Components.Navigation
  ( isDarkDefault_
  , navigation
  )
  where

import Prelude
import Web.HTML.HTMLElement

import Control.Monad.Maybe.Trans (MaybeT(..), runMaybeT)
import Data.Maybe (Maybe(..), maybe)
import Data.Traversable (for_, traverse, traverse_)
import Data.Tuple.Nested ((/\))
import Debug (spy)
import Effect (Effect)
import Next.Router (useRouter)
import Next.Router as Router
import NextUI.NextUI (switch, useTheme)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Events (targetChecked)
import React.Basic.Events (handler)
import React.Basic.Hooks (Component, component, useEffect, useEffectOnce, useState')
import React.Basic.Hooks as React
import React.Icons (icon)
import React.Icons.Si (siDiscord, siDiscourse, siGithub, siPurescript)
import React.Util (el)
import Themes (getColorValue)
import Web.DOM.Document (documentElement)
import Web.DOM.Element as DOMEL
import Web.HTML (window)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.HTMLDocument as Doc
import Web.HTML.Window (document)
-- radial-gradient(20rem 20rem at left 15rem top 20rem, rgba(30, 144, 255,0.5) 0% 10%,#0000 90% 90%),
mkBackgroundImage isDark =
  if isDark then
    """
      radial-gradient(25rem 25rem at left 15rem top 20rem, rgba(30, 144, 255,0.55) 0% 10%,#0000 90% 90%),
      radial-gradient(45rem 45rem at left 70rem top 40rem, rgba(0, 0, 139, 0.75) 0% 10%, #0000 70% 80%);
      """
  else
    """
      radial-gradient(25rem 25rem at left 15rem top 20rem, rgba(32, 178, 170, 0.25) 0% 10%,#0000 90% 90%),
      radial-gradient(45rem 45rem at left 70rem top 40rem, rgba(30, 144, 255, 0.25) 0% 10%,#0000 70% 80%);
      """
foreign import isDarkDefault_ :: Effect Boolean

navigation :: Component Unit
navigation = do
  component "Navbar" \_props -> React.do

    { theme } <- useTheme
    router <- useRouter
    let
      dispatchRoute = Router.push router
    isDarkPreference /\ setIsDarkPreference <- useState' true
    isDark /\ setDark <- useState' isDarkPreference
    _ <- useEffectOnce do 
          isDarkDefault <- isDarkDefault_
          setIsDarkPreference $ spy "Setting isDarkDefault " isDarkDefault
          pure mempty
    _ <- useEffect [ isDark ] do
      w <- window
      htmlDocument <- document w
      maybeElem <- htmlDocument # toDocument # documentElement
      case maybeElem of
        Just el -> do
          (DOMEL.setAttribute "class" if (spy "isDark" $ isDark) then "dark-theme" else "light-theme") el
          bodyElem <- runMaybeT do
            body <- MaybeT $ Doc.body htmlDocument
            pure $ toElement body
          maybe (pure unit) (DOMEL.setAttribute "style" ("background-image: " <> mkBackgroundImage isDark)) bodyElem
          pure mempty
        Nothing -> pure mempty
    pure $ el NextUI.navbar { isBordered: isDark, variant: "static" }
      [ el NextUI.navbarBrand {}
          $ el NextUI.link
              { onClick: dispatchRoute $ "/"
              }
          $ icon siPurescript { style: css { color: getColorValue theme "neutral" }, size: "3rem" }
      , el NextUI.navbarContent { hideIn: "xs" } $ map (mkLink theme)
          [ { onClick: dispatchRoute "/packages", title: "Getting started" }
          , { onClick: dispatchRoute "/packages", title: "Try Purescript" }
          , { onClick: dispatchRoute "/packages", title: "Packages" }
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
              { href: "https://github.com/purescript/purescript"
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
