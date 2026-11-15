{ ... }:

{
  services.glance = {
    enable = true;

    settings = {
      server = {
        host = "127.0.0.1";
        port = 8080;
        proxied = true;
      };

      pages = [
        {
          name = "Home";
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

            {
              size = "small";
              widgets = [
                {
                  type = "markets";
                  markets = [
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
            }
          ];
        }
      ];
    };
  };
}
