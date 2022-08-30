module Components.Navigation
  ( isDarkDefault_
  , navigation
  ) where

import Prelude
import Web.HTML.HTMLElement (toElement)

import Control.Monad.Maybe.Trans (MaybeT(..), runMaybeT)
import Data.Maybe (Maybe(..), maybe)
import Data.Traversable (traverse_)
import Effect (Effect)
import Next.Router (useRouter)
import Next.Router as Router
import NextUI.NextUI (switch, useNextTheme, useTheme)
import NextUI.NextUI as NextUI
import React.Basic.DOM (css)
import React.Basic.DOM.Events (targetChecked)
import React.Basic.Events (handler)
import React.Basic.Hooks (Component, component, useEffect)
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
mkBackgroundImage :: Boolean -> String
mkBackgroundImage isDark =
  if isDark then
    """
      radial-gradient(20rem 20rem at left 15rem top 20rem, rgba(37,246,255, 0.5) 5%,#0000 50%),
      radial-gradient(45rem 45rem at left 70rem top 40rem, rgba(24, 15, 102, 1) 5%, #0000 50%);
      """
  else
    """
      radial-gradient(20rem 20rem at left 15rem top 20rem, rgba(51,138, 255, 0.75) 5%, rgba(255,255,255,0) 50%),
      radial-gradient(45rem 45rem at left 70rem top 40rem, rgba(33,170,231, 0.75) 5%, rgba(255,255,255,0) 50%);
      """

foreign import isDarkDefault_ :: Effect Boolean

navigation :: Component Unit
navigation = do
  component "Navbar" \_props -> React.do

    { theme, isDark } <- useTheme
    { setTheme } <- useNextTheme
    router <- useRouter
    let
      dispatchRoute = Router.push router
      currentRoute = Router.route router

      setDark false = setTheme "light"
      setDark true = setTheme "dark"

    _ <- useEffect [ isDark ] do
      w <- window
      htmlDocument <- document w
      maybeElem <- htmlDocument # toDocument # documentElement
      case maybeElem of
        Just el -> do
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
          [ { onClick: dispatchRoute "/getting-started", title: "Getting started", isActive: currentRoute == "/getting-started" }
          , { onClick: dispatchRoute "/try", title: "Try", isActive: currentRoute == "/try" }
          , { onClick: dispatchRoute "/packages", title: "Packages", isActive: currentRoute == "/packages" }
          ]
      , el NextUI.navbarContent {}
          [ el NextUI.navbarLink
              { href: "https://purescript.org/chat"
              }
              $ icon siDiscord { style: css { color: getColorValue theme "neutral" }, size: "1.5rem" }
          , el NextUI.navbarLink
              { href: "https://discourse.purescript.org/"
              , target: "_blank"
              }
              $ icon siDiscourse { style: css { color: getColorValue theme "neutral" }, size: "1.5rem" }
          , el NextUI.navbarLink
              { href: "https://github.com/purescript/purescript"
              , target: "_blank"
              }
              $ icon siGithub { style: css { color: getColorValue theme "neutral" }, size: "1.5rem" }
          , el switch { checked: isDark, onChange: handler targetChecked $ traverse_ setDark } ""

          ]
      , el NextUI.navbarToggle { hideIn: "mdMax" } React.empty -- [TODO] Find out why it is not hiding
      ]
  where
  mkLink theme { onClick, title, isActive } =
    el NextUI.navbarLink
      { onClick
      , isActive
      , variant: "underline"
      }
      $ el NextUI.text { size: "$xl", color: getColorValue theme "neutral" } title
