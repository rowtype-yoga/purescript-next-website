let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20221018/packages.dhall
        sha256:b1db2e4a17260ace8d17858602f8c56f460982d6e404818d7f6cb9f053324bb1

in  upstream
  with nextui = ../purescript-nextui/spago.dhall as Location
  with nextjs = ../purescript-nextjs/spago.dhall as Location
  with yoga-json =
      upstream.yoga-json // { version = "v4.0.1" }
