{ pkgs ? import <nixpkgs> {}, ...} :{
  environment.systemPackages = with pkgs; [
    python3
    (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-vscode-remote.remote-ssh
      vscodevim.vim
      arrterian.nix-env-selector
      github.copilot
      github.copilot-chat
      arcticicestudio.nord-visual-studio-code
    ];
    })
  ];
}
