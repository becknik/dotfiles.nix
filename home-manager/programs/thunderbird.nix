{ config, ... }:

{
  programs.thunderbird = {
    enable = true;

    profiles."default" = {
      isDefault = true;
      withExternalGnupg = true;

      # TODO how is this intended to be used?
      # https://github.com/nix-community/home-manager/pull/5613

      # feedAccounts = {
      #   name1 = {
      #     name = "name2";
      #   };
      # };
    };

    settings = {
      "privacy.donottrackheader.enabled" = true;
      "accessibility.typeaheadfind.flashBar" = 0;

      "browser.crashReports.unsubmittedCheck.autoSubmit2" = true;
      "browser.download.lastDir" = config.xdg.userDirs.download;

      "calendar.alarms.defaultsnoozelength" = 10;
      "calendar.date.format" = 1;
      "calendar.view.dayendhour" = 21;
      "calendar.view.showLocation" = false;
      "calendar.view.visiblehours" = 13;
      "calendar.week.start" = 1;

      "extensions.ui.dictionary.hidden" = false;
      "extensions.ui.lastCategory" = "addons://list/dictionary";
      "extensions.ui.locale.hidden" = true;

      "general.autoScroll" = true;
      "general.smoothScroll" = true;

      "mail.SpellCheckBeforeSend" = true;
      "mail.compose.add_link_preview" = true;
      "mail.compose.default_to_paragraph" = false;
      "mail.e2ee.auto_disable" = true;
      "mail.e2ee.auto_enable" = true;
      "mail.phishing.detection.enabled" = false;
      "mail.purge.ask" = false;

      "mail.openpgp.allow_external_gnupg" = true;
      "mail.openpgp.fetch_pubkeys_from_gnupg" = true;

      "msgcompose.font_face" = "monospace";
      "msgcompose.font_size" = "4";

      "network.cookie.cookieBehavior" = 3;
      "places.history.enabled" = false;
      "spellchecker.dictionary" = "en-US,de-DE";
    };
  };
}
