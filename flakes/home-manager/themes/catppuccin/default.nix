{ pkgs, catppuccin, ... }: {
    
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "teal";
    pointerCursor = {
      enable = true;
      accent = "teal";
    };
  };
}