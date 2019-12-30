# References:
# * Battery life: https://github.com/Dunedan/mbp-2016-linux/issues/24

{ pkgs, lib, ... }:

let
  inherit (lib) mkOption types;
in
{
  options = {
    hardware.macbook = {
      model =
        mkOption {
          type = types.nullOr types.str;
          example = "11,5";
          default = null;
          description = ''
            Set the macbook model number.
            You can identify your macbook via https://support.apple.com/en-us/HT201608
          '';
        };
    };
  };
}
