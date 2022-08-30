module Themes where

import Prelude

import Effect (Effect)
import NextUI.NextUI (Theme, createTheme)

foreign import data ThemeValue :: Type

foreign import getColorValue :: Theme -> String -> ThemeValue

-- https://color.adobe.com/Adjacent-Water-color-theme-10314234/
-- /* Color Theme Swatches in Hex */
-- .Adjacent-Water-1-hex { color: #180F66; }
-- .Adjacent-Water-2-hex { color: #1A33B2; }
-- .Adjacent-Water-3-hex { color: #328AFF; }
-- .Adjacent-Water-4-hex { color: #22ABE8; }
-- .Adjacent-Water-5-hex { color: #25F5FF; }

-- /* Color Theme Swatches in RGBA */
-- .Adjacent-Water-1-rgba { color: rgba(23, 14, 102, 1); }
-- .Adjacent-Water-2-rgba { color: rgba(25, 51, 177, 1); }
-- .Adjacent-Water-3-rgba { color: rgba(49, 137, 255, 1); }
-- .Adjacent-Water-4-rgba { color: rgba(33, 170, 232, 1); }
-- .Adjacent-Water-5-rgba { color: rgba(36, 244, 255, 1); }

-- /* Color Theme Swatches in HSLA */
-- .Adjacent-Water-1-hsla { color: hsla(245, 74, 22, 1); }
-- .Adjacent-Water-2-hsla { color: hsla(229, 74, 39, 1); }
-- .Adjacent-Water-3-hsla { color: hsla(214, 100, 59, 1); }
-- .Adjacent-Water-4-hsla { color: hsla(198, 81, 52, 1); }
-- .Adjacent-Water-5-hsla { color: hsla(182, 100, 57, 1); }

mkDark :: Effect Theme
mkDark = createTheme
  { "type": "dark"
  , theme:
      { colors:
          { primaryLight: "$blue200"
          , primaryLightHover: "$blue300"
          , primaryLightActive: "$blue400"
          , primaryLightContrast: "$blue600"
          , primary: "rgb(26 51 178)"
          , primaryBorder: "$blue500"
          , primaryBorderHover: "$blue600"
          , primarySolidHover: "$blue700"
          , primarySolidContrast: "$white"
          , primaryShadow: "$cyan200"
          , selection: "rgb(138, 43, 226)"
          , gradient: "linear-gradient(112deg, $blue100 -25%, $pink500 -10%, $blue500 80%)"
          , link: "$blue700"
          , neutral: "$white300"
          , secondary: "$white300"
          , transparentBackground: "rgba(0,0,0,0.25);"
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
          , primaryLightHover: "$blue300"
          , primaryLightActive: "$blue400"
          , primaryLightContrast: "$blue600"
          , primary: "rgb(24,15,102)"
          , primaryBorder: "$blue300"
          , primaryBorderHover: "$blue600"
          , primarySolidHover: "$blue400"
          , primarySolidContrast: "$black100"
          , primaryShadow: "$blue800"
          , selection: "$red200"
          , gradient: "linear-gradient(112deg, $blue100 -25%, $pink500 -10%, $purple500 80%)"
          , link: "$black100"
          , neutral: "$blue900"
          , secondary: "#E9E9F2"
          , transparentBackground: "rgba(255,255,255,0.25);"
          }
      , space: {}
      , fonts:
          { sans: "Manrope, -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;"
          , mono: "Menlo, Monaco, 'Lucida Console', 'Liberation Mono', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono'"
          }
      }
  }
