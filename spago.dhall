{ name = "next-website"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "arrays"
  , "bifunctors"
  , "colors"
  , "console"
  , "debug"
  , "effect"
  , "either"
  , "fetch"
  , "fetch-yoga-json"
  , "foldable-traversable"
  , "foreign"
  , "functions"
  , "js-uri"
  , "maybe"
  , "newtype"
  , "nextjs"
  , "nextui"
  , "nullable"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "react-icons"
  , "react-markdown"
  , "remotedata"
  , "strings"
  , "transformers"
  , "tuples"
  , "unsafe-coerce"
  , "web-dom"
  , "web-html"
  , "yoga-json"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
