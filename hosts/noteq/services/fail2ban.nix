{ ... }:

{
  services.fail2ban = {
    enable = true;

    maxretry = 3;
    bantime = "1h";

    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32";
      maxtime = "1w";
      overalljails = true;
    };

    ignoreIP = [
      "127.0.0.1/8"
      "::1"
    ];

    jails = {
      sshd.settings = {
        enabled = true;
        backend = "systemd";
        mode = "aggressive";
        maxretry = 3;
        findtime = "10m";
        bantime = "1h";
      };

      caddy-4xx.settings = {
        enabled = true;
        backend = "auto";
        filter = "caddy-4xx";
        logpath = "/var/log/caddy/access-*.log";
        maxretry = 40;
        findtime = "5m";
        bantime = "30m";
      };
    };
  };

  environment.etc."fail2ban/filter.d/caddy-4xx.conf".text = ''
    [Definition]
    datepattern = "ts":<DATE>
    failregex = ^.*"(?:client_ip|remote_ip)":"<HOST>".*"status":(?:401|403|404|429).*$
    ignoreregex =
  '';
}
