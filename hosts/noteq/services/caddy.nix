{ ... }:

let
  hstsHeaders = ''
    header {
      Strict-Transport-Security "max-age=31536000"
    }
  '';

  autheliaForwardAuth = ''
    forward_auth 127.0.0.1:9091 {
      uri /api/authz/forward-auth
      copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
    }
  '';
in
{
  services.caddy = {
    enable = true;

    virtualHosts."auth.kotsh.in".extraConfig = ''
      ${hstsHeaders}
      reverse_proxy 127.0.0.1:9091
    '';

    virtualHosts."ac.kotsh.in".extraConfig = ''
      ${hstsHeaders}
      reverse_proxy 127.0.0.1:5006
    '';

    virtualHosts."glance.kotsh.in".extraConfig = ''
      ${hstsHeaders}
      ${autheliaForwardAuth}

      reverse_proxy 127.0.0.1:8080
    '';

    # virtualHosts."vault.kotsh.in".extraConfig = ''
    #   ${hstsHeaders}
    #
    #   @admin path /admin /admin/*
    #   handle @admin {
    #     ${autheliaForwardAuth}
    #
    #     reverse_proxy 127.0.0.1:8222
    #   }
    #
    #   reverse_proxy 127.0.0.1:8222
    # '';
  };
}
