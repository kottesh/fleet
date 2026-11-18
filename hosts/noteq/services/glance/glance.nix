{ ... }:

{
  services.glance = {
    enable = true;

    settings = {
      server = {
        host = "127.0.0.1";
        port = 8080;
        proxied = true;
        assets-path = toString ./.;
      };

      theme = {
        custom-css-file = "/assets/glance.css";
        background-color = "240 13 14";
        primary-color = "51 33 68";
        negative-color = "358 100 68";
        contrast-multiplier = 1.2;
      };
      pages = [
        {
          name = "Home";
          head-widgets = [
            {
              type = "markets";
              markets = [
                {
                  symbol = "^NSEI";
                  name = "NIFTY 50";
                }
                {
                  symbol = "KLAC";
                  name = "KLA Corporation";
                }
                {
                  symbol = "NIFTYBEES.NS";
                  name = "Nifty Bees";
                }
                {
                  symbol = "GOLDBEES.NS";
                  name = "Gold Bees";
                }
              ];
            }
          ];
          columns = [
            {
              size = "small";
              widgets = [
                { type = "calendar"; }
                {
                  type = "weather";
                  location = "Coimbatore, India";
                  units = "metric";
                  hour-format = "24h";
                }
              ];
            }

            {
              size = "full";
              widgets = [
                { type = "server-stats"; }
                {
                  type = "group";
                  widgets = [
                    {
                      type = "hacker-news";
                      limit = 10;
                    }
                    {
                      type = "rss";
                      limit = 10;
                      collapse-after = 5;
                      feeds = [
                        {
                          url = "https://hnrss.org/frontpage";
                          title = "Hacker News";
                        }
                        {
                          url = "https://lobste.rs/rss";
                          title = "Lobsters";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            # {
            #   size = "small";
            #   widgets = [
            #   ];
            # }
          ];
        }
      ];
    };
  };
}
