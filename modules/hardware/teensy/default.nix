{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.teensy;

  teensy = pkgs.writeTextFile {
    # Enable user access to teensy USB development board
    name = "teensy";
    text = ''
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
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
          By default, a teensy group is created for this purpose.
        '';
      };
      # TODO
      # group = mkOption {
      #   type = types.str;
      #   default = "teensy";
      #   example = "users";
      #   description = ''
      #     Grant access to teensy devices to users in this group.
      #   '';
      # };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ teensy ];
  };
}

