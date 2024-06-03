{ pkgs ? import <nixpkgs> {}, ...} :{
  environment.systemPackages = with pkgs; [
    python3
    (unstable.vscode-with-extensions.override {
    vscodeExtensions = with unstable.vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-vscode-remote.remote-ssh
      vscodevim.vim
      arrterian.nix-env-selector
      github.copilot
      github.copilot-chat
    ];
    })
  ];
}
