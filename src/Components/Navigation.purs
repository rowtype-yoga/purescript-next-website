module Components.Navigation
  ( isDarkDefault_
  , navigation
  ) where

import Prelude

import Control.Monad.Maybe.Trans (MaybeT(..), runMaybeT)
import Data.Maybe (Maybe(..), maybe)
import Data.Traversable (traverse_)
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
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
import Web.HTML.HTMLElement (toElement)
import Web.HTML.Window (document)

-- radial-gradient(20rem 20rem at left 15rem top 20rem, rgba(30, 144, 255,0.5) 0% 10%,#0000 90% 90%),
mkBackgroundImage :: Boolean -> String
mkBackgroundImage isDark =
  if isDark then
    """
      radial-gradient(40% 40% at 80% 20%, #05C7F2CC 1%, #0597F200 100%),radial-gradient(50% 60% at 25% 75%, #0597F2DD 0%, #3866F200 100%),radial-gradient(40% 40% at 0% 50%, #FFFFFFAA 1%, #05C7F200 100%),radial-gradient(30% 30% at 20% 40%, #6F04D9 0%, #1B027300 100%),radial-gradient(60% 70% at 50% 30%, #3866F2 25%, #1B027300 100%),linear-gradient(135deg, #000000FF 0%, #1B0273 100%)
      """
  else
    """
      radial-gradient(40% 40% at 20% 60%, #3866F233 8%, #FFFFFF00 100%),radial-gradient(75% 75% at 75% 25%, #6F04D922 8%, #05C7F200 100%),linear-gradient(152deg, #FFFFFFFF 22%, #05C7F255 100%)
      """

foreign import isDarkDefault_ :: Effect Boolean

navigation :: Component Unit
navigation = do
  component "Navbar" \_props -> React.do

    { theme, isDark } <- useTheme
    { setTheme } <- useNextTheme
    router <- useRouter
    let
      dispatchRoute = flip Router.push_ router
      currentRoute = Router.asPath router

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
          maybe (pure unit) (DOMEL.setAttribute "style" ("background-image: " <> mkBackgroundImage isDark <> ";background-attachment:scroll;" )) bodyElem
          pure mempty
        Nothing -> pure mempty
    pure $ el NextUI.navbar { isBordered: isDark, variant: "static" }
      [ el NextUI.navbarBrand { color: "neutral"}
          $ el NextUI.link
              { onClick: dispatchRoute $ "/"
              }
          $ icon siPurescript { size: "3rem" }
      , el NextUI.navbarContent { hideIn: "xs" } $ map (mkLink theme)
          [ { onClick: dispatchRoute "/getting-started", title: "Getting started", isActive: unsafePerformEffect currentRoute == "/getting-started" }
          , { onClick: dispatchRoute "/try", title: "Try", isActive: unsafePerformEffect currentRoute == "/try" }
          , { onClick: dispatchRoute "/packages", title: "Packages", isActive: unsafePerformEffect currentRoute == "/packages" }
          ]
      , el NextUI.navbarContent {}
          [ el NextUI.navbarLink
              { href: "https://purescript.org/chat"
              , target: "_blank"
              }
              $ icon siDiscord { style: css { color: "neutral" }, size: "1.5rem" }
          , el NextUI.navbarLink
              { href: "https://discourse.purescript.org/"
              , target: "_blank"
              }
              $ icon siDiscourse { style: css { color: "neutral" }, size: "1.5rem" }
          , el NextUI.navbarLink
              { href: "https://github.com/purescript/purescript"
              , target: "_blank"
              }
              $ icon siGithub { style: css { color: "neutral" }, size: "1.5rem" }
          , el switch { checked: isDark, css: css { color: "neutral"}, onChange: handler targetChecked $ traverse_ setDark } ""

          ]
      , el NextUI.navbarToggle { hideIn: "mdMax"} React.empty -- [TODO] Find out why it is not hiding
      ]
  where
  mkLink theme { onClick, title, isActive } =
    el NextUI.navbarLink
      { onClick
      , isActive
      , variant: "underline"
      }
      $ el NextUI.text { size: "$2xl", color: "neutral" } title
