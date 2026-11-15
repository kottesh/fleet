{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Shree Kottes";
        email = "kottesh.j@gmail.com";
      };
      pull = {
        rebase = true;
      };
    };
  };
}
