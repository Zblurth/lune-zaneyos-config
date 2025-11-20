{
  pkgs,
  pkgs-unstable,
  chaotic,
  inputs,
  ...
}:
{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    firefox.enable = false; # Firefox is not installed by default
    hyprland = {
      enable = true; # set this so desktop file is created
      withUWSM = false;
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = true;
    hyprlock.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Hyprland systeminfo QT  (Optional)
    #inputs.hyprsysteminfo.packages.${pkgs.system}.default

    vivaldi # Vivaldi Browser
    vesktop # Discord Made Linux Friendly
    zed-editor # Mordern Rust Based Text Editor
    hyfetch # Neofetch but GAY
    xfce.thunar # File Manager with a GUI
    p7zip # Tool that read p7zip
    file-roller # Gui for Unzipping
    xfce.thunar-archive-plugin # Link between Thunar and Fille-Roller
    btop # Task Manager

    ddcutil # Brightness Control
    i2c-tools #Brightness Control

    pkgs-unstable.deezer-enhanced # Deezer Streaming App
    pkgs-unstable.gemini-cli # Google Open Source LLM cli

    amfora # Fancy Terminal Browser For Gemini Protocol
    appimage-run # Needed For AppImage Support
    brightnessctl # For Screen Brightness Control
    cliphist # Clipboard manager using rofi menu
    duf # Utility For Viewing Disk Usage In Terminal
    dysk # Disk space util nice formattting
    eza # Beautiful ls Replacement
    ffmpeg # Terminal Video / Audio Editing
    file-roller # Archive Manager
    glxinfo # needed for inxi diag util
    greetd.tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
    htop # Simple Terminal Based System Monitor
    hyprpicker # Color Picker
    eog # For Image Viewing
    inxi # CLI System Information Tool
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    lm_sensors # Used For Getting Hardware Temps
    lolcat # Add Colors To Your Terminal Command Output
    lshw # Detailed Hardware Information
    mpv # Incredible Video Player
    ncdu # Disk Usage Analyzer With Ncurses Interface
    nixfmt-rfc-style # Nix Formatter
    nwg-displays # configure monitor configs via GUI
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    rhythmbox # audio player
    ripgrep # Improved Grep
    socat # Needed For Screenshots
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    uwsm # Universal Wayland Session Manager (optional must be enabled)
    v4l-utils # Used For Things Like OBS Virtual Camera
    waypaper  # wallpaper changer
    warp-terminal # Terminal with AI support build in
    wget # Tool For Fetching Files With Links

    #gedit # Simple Graphical Text Editor
    #cowsay # Great Fun Terminal Program
    #docker-compose # Allows Controlling Docker From A Single File
    #cmatrix # Matrix Movie Effect In Terminal
    #gimp # Great Photo Editor
    #onefetch # provides zsaneyos build info on current system
    #picard # For Changing Music Metadata & Getting Cover Art
    #ytmdl # Tool For Downloading Audio From YouTube
    # brave # Brave Browser
  ];
}
