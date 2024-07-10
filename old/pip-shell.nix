with import <nixpkgs> {};
mkShell {
  name = "pip-env";
  buildInputs = with pkgs; [
    python310
    python310Packages.pip
    python310Packages.numpy
    python310Packages.pandas
  ];
  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
    alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.7/site-packages:$PYTHONPATH"
    unset SOURCE_DATE_EPOCH
  '';
}