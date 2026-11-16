{ ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."auth.kotsh.in".extraConfig = ''
      reverse_proxy 127.0.0.1:9091
    '';

    virtualHosts."ac.kotsh.in".extraConfig = ''
      reverse_proxy 127.0.0.1:5006
    '';

    virtualHosts."glance.kotsh.in".extraConfig = ''
      forward_auth 127.0.0.1:9091 {
        uri /api/authz/forward-auth
        copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
      }

      reverse_proxy 127.0.0.1:8080
    '';
  };
}
