{ lib, pkgs, config, ... }:

let
  cfg = config.programs.clippy;
  inherit (lib) mkOption types;

  formatOption = char: opt: "-${char}${opt}";
  formatOptions = char: opts: builtins.map (opt: formatOption char opt) opts;
in
{
  meta.maintainers = [ ];

  options.programs.clippy = {
    enable = lib.mkEnableOption "clippy";

    package = mkOption {
      type = types.package;
      default = pkgs.clippy;
      description = ''
        Clippy package to use for this check.
      '';
    };


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

    edition = mkOption {
      type = types.str;
      default = "2021";
      description = ''
        Rust edition to target when formatting.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.clippy = {
      command = "${cfg.package}/bin/clippy-driver";
      options =
        formatOptions "A" cfg.allow ++
        formatOptions "W" cfg.warn ++
        formatOptions "D" cfg.deny ++
        [ "--edition" cfg.edition "--fix" ];
      includes = [ "*.rs" ];
    };
  };
}
