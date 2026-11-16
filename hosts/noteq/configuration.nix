{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/zsh.nix
    ../../modules/git.nix
    ../../modules/ssh.nix

    ./services/caddy.nix
    ./services/actual.nix
    ./services/glance.nix
    ./services/authelia.nix
  ];

  networking.hostName = "noteq";
  networking.domain = "minet.mainet.oraclevcn.com";
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = false;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
    "cma=0"
  ];

  boot.tmp.cleanOnBoot = true;

  boot.loader.grub = {
    configurationLimit = 2;
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.loader.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.kottesh = {
    isNormalUser = true;
    description = "kottesh";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGCyMURbS+/Lnem4F42lf0S38Mb9YplkBsLUgkVrcPZu kottesh.j@gmail.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
    priority = 100;
    algorithm = "zstd";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    max-jobs = 1;
    cores = 1;
    auto-optimise-store = false;
    substituters = [ "https://cache.nixos.org/" ];
  };

  documentation.enable = false;
  documentation.nixos.enable = false;
  programs.command-not-found.enable = false;

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    RuntimeMaxUse=50M
  '';

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    wget
    htop
    tmux
    neovim
    miniserve
    bottom
    jq
    dig
    lsof
    nixfmt
    bat
    ripgrep
    fzf
  ];

  system.stateVersion = "22.05";
}
