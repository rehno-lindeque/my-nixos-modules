{ lib, ... }:

# Contains some useful option aliases

with lib;

{
  imports = [
    (mkAliasOptionModule [ "hardware" "macbook" "leds" ] [ "hardware" "leds" ])
  ];
}
