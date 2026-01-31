{
  pkgs,
  ...
}:

{
  # Enable Zsh at system level
  programs.zsh.enable = true;

  users.users.abayoumy = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    initialPassword = "changeme"; # Set initial password
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnx9o70Hv7J/vTjdnae0bttA5X5UtDtqzhJVkH7dSlq abayoumy@macbook"
    ];
  };

  # Allow sudo without password
  security.sudo.extraRules = [
    {
      users = [ "abayoumy" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Generate SSH key for abayoumy if it doesn't exist
  system.activationScripts.generateSSHKey = {
    text = ''
      if [ ! -f /home/abayoumy/.ssh/id_ed25519 ]; then
        mkdir -p /home/abayoumy/.ssh
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -f /home/abayoumy/.ssh/id_ed25519
        chown -R abayoumy:users /home/abayoumy/.ssh
        chmod 700 /home/abayoumy/.ssh
        chmod 600 /home/abayoumy/.ssh/id_ed25519
        chmod 644 /home/abayoumy/.ssh/id_ed25519.pub
      fi
    '';
  };
}
