{ ... }:

let
  mkOidcClient =
    {
      id,
      name,
      secretHash,
      redirectUris,
      policy ? "two_factor",
      pkce ? false,
    }:
    {
      client_id = id;
      client_name = name;
      client_secret = secretHash;
      public = false;
      authorization_policy = policy;
      require_pkce = pkce;
      pkce_challenge_method = if pkce then "S256" else "";
      redirect_uris = redirectUris;

      scopes = [
        "openid"
        "profile"
        "email"
        "groups"
      ];

      response_types = [ "code" ];
      grant_types = [ "authorization_code" ];

      access_token_signed_response_alg = "none";
      userinfo_signed_response_alg = "none";
      token_endpoint_auth_method = "client_secret_basic";
    };
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/authelia-main 0700 authelia-main authelia-main -"
    "d /var/lib/authelia-main/secrets 0700 authelia-main authelia-main -"
    "z /var/lib/authelia-main/users_database.yml 0600 authelia-main authelia-main -"
    "z /var/lib/authelia-main/secrets/jwt 0600 authelia-main authelia-main -"
    "z /var/lib/authelia-main/secrets/session 0600 authelia-main authelia-main -"
    "z /var/lib/authelia-main/secrets/storage 0600 authelia-main authelia-main -"
    "z /var/lib/authelia-main/secrets/oidc-hmac 0600 authelia-main authelia-main -"
    "z /var/lib/authelia-main/secrets/oidc-issuer-private-key.pem 0600 authelia-main authelia-main -"
  ];

  services.authelia.instances.main = {
    enable = true;

    secrets = {
      jwtSecretFile = "/var/lib/authelia-main/secrets/jwt";
      sessionSecretFile = "/var/lib/authelia-main/secrets/session";
      storageEncryptionKeyFile = "/var/lib/authelia-main/secrets/storage";
      oidcHmacSecretFile = "/var/lib/authelia-main/secrets/oidc-hmac";
      oidcIssuerPrivateKeyFile = "/var/lib/authelia-main/secrets/oidc-issuer-private-key.pem";
    };

    settings = {
      theme = "auto";
      default_2fa_method = "totp";

      identity_providers.oidc.clients = [
        (mkOidcClient {
          id = "actual-budget";
          name = "Actual Budget";
          secretHash = "$pbkdf2-sha512$310000$iyNLMWUS.o2JV3JNlKd9Yg$QOtHmbMaj3G8/tbfpkHm0.SwVLbdp2WrfPeDRvWKcF3t/0RTPrcqVfkmOKPiX9hwlyQp4cEo7X8rWGmJ8P/00Q";
          redirectUris = [ "https://ac.kotsh.in/openid/callback" ];
          pkce = false;
        })
      ];

      log = {
        level = "info";
        format = "text";
      };

      server = {
        address = "tcp://127.0.0.1:9091/";
        endpoints.authz.forward-auth.implementation = "ForwardAuth";
      };

      totp.issuer = "auth.kotsh.in";

      authentication_backend = {
        file.path = "/var/lib/authelia-main/users_database.yml";
        password_reset.disable = true;
      };

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "glance.kotsh.in";
            policy = "two_factor";
            subject = [ "group:admins" ];
          }
        ];
      };

      session.cookies = [
        {
          domain = "kotsh.in";
          authelia_url = "https://auth.kotsh.in";
          default_redirection_url = "https://glance.kotsh.in";
        }
      ];

      storage.local.path = "/var/lib/authelia-main/db.sqlite3";
      notifier.filesystem.filename = "/var/lib/authelia-main/notification.txt";
    };
  };
}
