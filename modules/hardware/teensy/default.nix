{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.teensy;

  teensy = pkgs.writeTextFile {
    # Enable user access to teensy USB development board
    name = "teensy";
    text = ''
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
      '';
    destination = "/etc/udev/rules.d/49-teensy.rules";
  };
in
{
  options = {
    hardware.teensy = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable teensy udev rules.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ teensy ];
  };
}

