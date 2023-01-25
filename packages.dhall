let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.7-20230124/packages.dhall
        sha256:c3aeda7c7deedd885d4889d33278955faa680053dbb9012d63272eea84217843

in  upstream
  with nextui =
    { repo = "https://github.com/rowtype-yoga/purescript-nextui.git"
    , version = "main"
    , dependencies = [ "effect", "prelude", "react-basic-hooks" ]
    }
