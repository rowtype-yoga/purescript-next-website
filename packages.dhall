let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20221018/packages.dhall
        sha256:b1db2e4a17260ace8d17858602f8c56f460982d6e404818d7f6cb9f053324bb1

in  upstream
  with nextui =
    { repo = "https://github.com/rowtype-yoga/purescript-nextui.git"
    , version = "main"
    , dependencies = [ "effect", "prelude", "react-basic-hooks" ]
    }
  with nextjs =
    { repo = "https://github.com/rowtype-yoga/purescript-nextjs.git"
    , version = "108fbcd0e45498c3ccdd07c0380420a269d85ca4" -- [todo] update to latest version
    , dependencies =
      [ "aff"
      , "aff-promise"
      , "console"
      , "effect"
      , "functions"
      , "maybe"
      , "nullable"
      , "prelude"
      , "react-basic"
      , "react-basic-hooks"
      ]
    }
  with yoga-json = upstream.yoga-json // { version = "v4.0.1" }
