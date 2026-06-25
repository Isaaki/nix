{ config, lib, ... }:

{
  options.custom.pipewire-combined = {
    enable = lib.mkEnableOption "Combined PipeWire sink";
    nodes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of node names to combine";
      example = [
        "alsa_output.usb-Focusrite_Scarlett_2i2-00.analog-stereo"
        "bluez_output.XX_XX_XX_XX_XX_XX.a2dp-sink"
      ];
    };
  };

  config = {
    security.rtkit.enable = true;
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "95";
      }
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 128;
          "default.clock.min-quantum" = 64;
          "default.clock.max-quantum" = 512;
        };
      };

      extraConfig.jack."99-autoconnect" = {
        "jack.properties" = {
          "node.autoconnect" = true;
        };
      };

      extraConfig.pipewire."99-combined-sink" = lib.mkIf config.custom.pipewire-combined.enable {
        "context.modules" = [
          {
            name = "libpipewire-module-combine-stream";
            args = {
              "combine.mode" = "sink";
              "node.name" = "combined_output";
              "node.description" = "Simultaneous Output";
              "combine.props" = {
                "audio.position" = [
                  "FL"
                  "FR"
                ];
              };
              "stream.rules" = map (node: {
                matches = [ { "node.name" = node; } ];
                actions = { "create-stream" = { }; };
              }) config.custom.pipewire-combined.nodes;
            };
          }
        ];
      };
    };
  };
}
