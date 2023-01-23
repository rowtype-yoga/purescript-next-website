module Themes where

import Prelude

import Effect (Effect)
import NextUI.NextUI (Theme, createTheme)

foreign import data ThemeValue :: Type

foreign import getColorValue :: Theme -> String -> ThemeValue

mkDark :: Effect Theme
mkDark = createTheme
  { "type": "dark"
  , theme:
      { colors:
          { theme1: "#6F04D9"
          , theme2: "#1B0273"
          , theme2a: "#1B0273AA"
          , theme3: "#3866F2"
          , theme4: "#0597F2"
          , theme5: "#05C7F2"
          , primaryLight: "$blue200"
          , primaryLightHover: "$white"
          , primaryLightActive: "$blue400"
          , primaryLightContrast: "$blue600"
          , primary: "$theme3"
          , primaryBorder: "$white"
          , primaryBorderHover: "$blue600"
          , primarySolidHover: "$theme5"
          , primarySolidContrast: "rgba(0,0,0,0)"
          , primaryShadow: "$theme2"
          , secondary: "$theme1"
          , selection: "$white"
          , gradient: "linear-gradient(135deg, $theme1 20%, #1B027300 80%)"
          , link: "$gray900"
          , neutral: "$gray900"
          , background: "$white"
          , codeLight: "rgba(0,0,0,0.2)"
          , code: "$white"
          , overlay: "rgba(0,0,0,0.2)"
          }
      , space: {}
      , fonts:
          { sans: "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;"
          , mono: "Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono'"
          }
      }
  }

mkLight :: Effect Theme
mkLight = createTheme
  { "type": "light"
  , theme:
      { colors:
          { theme1: "#6F04D9"
          , theme2: "#1B0273"
          , theme2a: "#1B0273AA"
          , theme3: "#3866F2"
          , theme4: "#0597F2"
          , theme5: "#05C7F2"
          , primaryLight: "$blue200"
          , primaryLightHover: "$purple300"
          , primaryLightActive: "$blue400"
          , primaryLightContrast: "$blue600"
          , primary: "$theme1"
          , primaryBorder: "$blue300"
          , primaryBorderHover: "$blue600"
          , primarySolidHover: "$blue400"
          , primarySolidContrast: "$black100"
          , primaryShadow: "$blue500"
          , gradient: "linear-gradient(112deg, $blue100 -25%, $pink500 -10%, $purple500 80%)"
          , link: "$black100"
          , neutral: "$blue900"
          , codeLight: "rgba(255,255,255,0.8)"
          , code: "$black"
          , overlay: "rgba(255,255,255,0.6)"
          }
      , space: {}
      , fonts:
          { sans: "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;"
          , mono: "Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono'"
          }
      }
  }
