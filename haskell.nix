{ pkgs ? import <nixpkgs> {}, student, branch, ...} : 

  pkgs.mkShell {
    nativeBuildInputs = with pkgs.buildPackages; [git ghc cabal-install];
    shellHook = ''
      mkdir /tmp/haskell
      cd /tmp/haskell
      git clone ssh://git@puh.takelab.fer.hr:2222/puh-23-24-assignments/${student}.git
      cd ${student}/
      git fetch origin
      git checkout ${branch}
    '';
  }
	
