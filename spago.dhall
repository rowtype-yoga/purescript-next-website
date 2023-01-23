{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "arrays"
  , "bifunctors"
  , "console"
  , "debug"
  , "effect"
  , "either"
  , "exceptions"
  , "fetch"
  , "fetch-yoga-json"
  , "foldable-traversable"
  , "foreign"
  , "js-bigints"
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
  , "record"
  , "remotedata"
  , "strings"
  , "transformers"
  , "tuples"
  , "typelevel-prelude"
  , "unsafe-coerce"
  , "web-dom"
  , "web-html"
  , "yoga-json"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
