{
  # /etc/nixos/configuration.nix
  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      root = ./results;
      extraConfig = ''
        listen 127.0.0.1:8349;
        listen [::1]:8349;
      '';
    };
  };

  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 2987;
        bind_address = "127.0.0.1";
        secret_key = "secret key";
        limiter = false;
        default_http_headers.Access-Control-Allow-Origin = "*";
      };
      search = {
        formats = ["json"];
      };
    };
  };
}
