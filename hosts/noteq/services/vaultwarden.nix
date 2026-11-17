{ ... }:

{
  services.vaultwarden = {
    enable = true;
    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";

    config = {
      DOMAIN = "https://vault.kotsh.in";

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;

      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;
      SHOW_PASSWORD_HINT = false;

      WEBSOCKET_ENABLED = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/vaultwarden 0700 vaultwarden vaultwarden -"
    "z /var/lib/vaultwarden/vaultwarden.env 0600 vaultwarden vaultwarden -"
  ];
}
