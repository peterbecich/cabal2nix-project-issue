{ mkDerivation, base, lib, text }:
mkDerivation {
  pname = "baz";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base text ];
  license = lib.licenses.mit;
  mainProgram = "bar";
}
