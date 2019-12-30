{ pkgs, config, lib, ... }:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.hardware.macbook;
in
{
  config = mkIf (!config.hardware.bluetooth.enable && cfg.model == "11,5") {
    # TODO: investigate whether this duplicates bluetooth.enabled = false;
    # Disabling the bluetooth controller may save battery life.
    # $ lsusb -d 05ac:8290
    # Bus 001 Device 002: ID 05ac:8290 Apple, Inc. Bluetooth Host Controller
    services.udev.packages =
      lib.singleton (pkgs.writeTextFile {
        name = "led-udev-rules";
        destination = "/etc/udev/rules.d/61-macbook-bluetooth.rules";
        text = ''
          SUBSYSTEMS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="8290", RUN+="${../../../../scripts/remove-usb-device.sh} 05ac 8290"
          '';
      });
  };
}

