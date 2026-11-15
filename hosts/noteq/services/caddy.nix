{ ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."ac.kotsh.in" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:5006
      '';
    };

    virtualHosts."glance.kotsh.in" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8080
      '';
    };
  };
}
