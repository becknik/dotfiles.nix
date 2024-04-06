{ ... }:

{
  # plasma-manager is a disappointment (by not creating the files I specified), so doing it the verbose but working way
  xdg.configFile = {
    kdeglobals = {
      target = "kdeglobals";
      source = ./files/plasma/kdeglobals.ini;
      # mutable = true; # TODO ???
    };

    okularpartrc = {
      target = "okularpartrc";
      source = ./files/plasma/okularpartrc.ini;
    };

    gwenviewrc = {
      target = "gwenviewrc";
      source = ./files/plasma/gwenviewrc.ini;
    };

    dolphinrc = {
      target = "dolphinrc";
      source = ./files/plasma/dolphinrc.ini;
    };

    kiorc = {
      target = "kiorc";
      source = ./files/plasma/kiorc.ini;
    };

    kservicemenurc = {
      target = "kservicemenurc";
      source = ./files/plasma/kservicemenurc.ini;
    };

    baloofilerc = {
      target = "baloofilerc";
      source = ./files/plasma/baloofilerc.ini;
    };
  };
}
