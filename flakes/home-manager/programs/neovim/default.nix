{ config, pkgs, lib, ... }: {
  programs.neovim.enable = true;

  home.packages = with pkgs; [
    python312Packages.flake8
    python312Packages.black
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

    #COC
    coc-spell-checker
    coc-prettier
    coc-git
    coc-pyright
    coc-json
    coc-docker
    coc-yaml
  ];
}