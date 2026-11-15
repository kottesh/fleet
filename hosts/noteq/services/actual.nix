{ pkgs-unstable, ... }:

{
  services.actual = {
    enable = true;
    package = pkgs-unstable.actual-server;

    settings = {
      hostname = "127.0.0.1";
      port = 5006;
    };
  };
}
