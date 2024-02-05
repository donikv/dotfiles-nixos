{ pkgs ? import <nixpkgs> {}, ...} :{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-vscode-remote.remote-ssh
      vscodevim.vim
      arrterian.nix-env-selector
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.46.6822";
        sha256 = "sha256-L71mC0190ZubqNVliu7es4SDsBTGVokePpcNupABI8Q=";
      }];
     })
  ];
}
