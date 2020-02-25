{ config, lib, pkgs, ... }:

# See also
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
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ baslerCamera ];
  };
}

