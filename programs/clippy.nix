{ lib, pkgs, config, ... }:

let
  cfg = config.programs.clippy;
  inherit (lib) mkOption types;

  formatOption = char: opt: "-${char}${opt}";
  formatOptions = char: opts: builtins.map (opt: formatOption char opt) opts;
in
{
  options.programs.clippy = {
    enable = lib.mkEnableOption "clippy";

    allow = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Set of clippy warnings to permit.
      '';
    };

    warn = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Set of clippy warnings to display warnings on finding.
      '';
    };

    deny = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Set of clippy warnings to fail on finding.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.clippy;
      description = ''
        Clippy package to use for this check.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.clippy = {
      command = "${cfg.package}/bin/clippy-driver";
      options =
        formatOptions "A" cfg.allow +
        formatOptions "W" cfg.warn +
        formatOptions "D" cfg.deny +
        [ "--fix" ];
      includes = [ "*.rs" ];
    };
  };
}
