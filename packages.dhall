let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.7-20230130/packages.dhall
        sha256:63189ab110ac8add19149c5c42b0c044b97f96d7cbe0505c140974061a786141

in  upstream
  with nextui =
    { repo = "https://github.com/rowtype-yoga/purescript-nextui.git"
    , version = "v0.2.0"
    , dependencies = [ "effect", "prelude", "react-basic-hooks" ]
    }
