{ config, lib, pkgs, ... }:

# See also
# * https://www.baslerweb.com/en/support/downloads/software-downloads/pylon-5-0-9-linux-x86-64-bit/
# * https://www.baslerweb.com/fp-1496750153/media/downloads/software/pylon_software/pylon-5.0.9.10389-x86_64.tar.gz
# * https://github.com/AravisProject/aravis/blob/master/aravis.rules

with lib;
let
  cfg = config.hardware.baslerCamera;

  baslerCamera = pkgs.writeTextFile {
    # Enable user access to all basler cameras
    name = "basler-camera";
    text = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2676", MODE:="0666", TAG+="uaccess"
      '';
    destination = "/etc/udev/rules.d/69-basler-camera.rules";
  };
in
{
  options = {
    hardware.baslerCamera = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable basler udev rules.
          By default, a basler group is created for this purpose.
        '';
      };
      # TODO
      # group = mkOption {
      #   type = types.str;
      #   default = "basler";
      #   example = "users";
      #   description = ''
      #     Grant access to basler devices to users in this group.
      #   '';
      # };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ baslerCamera ];
  };
}

