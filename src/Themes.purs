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
          { primaryLight: "$blue200"
          , primaryLightHover: "$blue300"
          , primaryLightActive: "$blue400"
          , primaryLightContrast: "$blue600"
          , primary: "$blue700"
          , primaryBorder: "$blue500"
          , primaryBorderHover: "$blue600"
          , primarySolidHover: "$blue700"
          , primarySolidContrast: "$white"
          , primaryShadow: "$blue500"
          , gradient: "linear-gradient(112deg, $blue100 -25%, $pink500 -10%, $blue500 80%)"
          , link: "$blue700"
          , neutral: "$white300"
          }
      , space: {}
      , fonts:
          { sans: "Manrope, -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;"
          , mono: "Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono'"
          }
      }
  }

mkLight :: Effect Theme
mkLight = createTheme
  { "type": "light"
  , theme:
      { colors:
          { primaryLight: "$blue200"
          , primaryLightHover: "$purple300"
          , primaryLightActive: "$blue400"
          , primaryLightContrast: "$blue600"
          , primary: "$blue200"
          , primaryBorder: "$blue300"
          , primaryBorderHover: "$blue600"
          , primarySolidHover: "$blue400"
          , primarySolidContrast: "$blue600"
          , primaryShadow: "$blue500"
          , gradient: "linear-gradient(112deg, $blue100 -25%, $pink500 -10%, $purple500 80%)"
          , link: "$black100"
          , neutral: "$blue900"
          }
      , space: {}
      , fonts:
          { sans: "Manrope, -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;"
          , mono: "Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono'"
          }
      }
  }
