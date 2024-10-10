{ config, pkgs, lib, distant, ... }: {
  programs.neovim.enable = true;

  home.packages = with pkgs; [
    #distant
    nodejs_22
  ];


  programs.neovim.extraConfig = lib.fileContents ./config/init.vim;

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

  programs.neovim.plugins = with pkgs.vimPlugins; [
    ctrlp-vim
    nerdcommenter
    matchit-zip
    nerdtree
    vim-airline
    vim-airline-themes
    nord-vim
    vim-polyglot
    vim-fugitive
    auto-pairs
    copilot-vim
    distant-nvim

    #COC
    coc-nvim
    coc-spell-checker
    coc-prettier
    coc-git
    coc-pyright
    coc-json
    coc-docker
    coc-yaml
  ];
  programs.neovim = {
    withPython3 = true;
    extraPackages = with pkgs; [
      (python3.withPackages (ps: with ps; [
        black
        flake8
      ]))
    ];
    extraPython3Packages = (ps: with ps; [
      jedi
    ]);
  };

  home.file.".config/nvim/coc-settings.json".text = builtins.readFile ./config/coc-settings.json;
}
