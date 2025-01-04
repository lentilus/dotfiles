{config, ...}: let
  colors = config.stylix.base16Scheme;
  font = config.stylix.fonts.monospace.name;
  black = "#${colors.base00}";
  white = "#${colors.base04}";
  red = "#${colors.base08}";
  brightWhite = "#${colors.base07}";
  yellow = "#${colors.base0A}";
  green = "#${colors.base0B}";
in ''
  * {
      font-family: ${font};
      font-size: 14px;
      border: none;
      margin: 0;
      border-radius: 0;
  }

  window#waybar {
      background-color: ${black};
      color: ${white};
  }

  #workspaces button {
      padding: 0 0px;
      color: ${white};
  }

  #workspaces button.focused {
      background-color: ${white};
      color: ${black};
  }

  #network.disconnected {
      color: ${red};
  }

  #network:not(.disconnected) {
      color: ${green};
  }

  #idle_inhibitor.activated {
      color: ${brightWhite};
  }

  #pulseaudio.muted {
      color: ${yellow};
  }

  @keyframes blink {
      to {
          background-color: #ffffff;
          color: #000000;
      }
  }

  #battery.critical:not(.charging) {
      background-color: #f53c3c;
      color: #ffffff;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: steps(12);
      animation-iteration-count: infinite;
      animation-direction: alternate;
  }
''
