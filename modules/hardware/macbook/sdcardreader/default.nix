{ pkgs, config, lib, ... }:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.hardware.macbook.sdCardReader;
in
{
  options = {
    hardware.macbook.sdCardReader = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Disabling the internal cardreader may save battery life. Set this to false to turn it off.
        '';
      };
    };
  };

  config = mkIf (!cfg.enable) {
    assertions = [ {
      assertion = config.hardware.macbook.model == "11,5";
      message = "sd-card reader can only be disabled on macbook pro hardware model 11,5";
    } ];

    services.udev.packages =
      # See https://wiki.archlinux.org/index.php/MacBookPro11,x#Powersave
      # $ lsusb -d 05ac:8406
      # Bus 002 Device 002: ID 05ac:8406 Apple, Inc.
      lib.singleton (pkgs.writeTextFile {
        name = "macbook-sdcardreader-udev-rules";
        destination = "/etc/udev/rules.d/61-macbook-sdcardreader.rules";
        text = ''
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="8406", RUN+="${../../../../scripts/remove-usb-device.sh} 05ac 8406"
          '';
      });
  };
}
