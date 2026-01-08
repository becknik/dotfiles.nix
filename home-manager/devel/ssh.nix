{ ... }:

{
  programs.ssh = {
    enable = true;

    includes = [ "~/.ssh/config.local" ];

    matchBlocks = {
      "*" = {
        forwardAgent = true;
        hashKnownHosts = true;
        addKeysToAgent = "yes";
      };

      github_personal = {
        host = "github.com";
        user = "git";
        identityFile = "~/.ssh/github-becknik";
      };
      gitlab_personal = {
        host = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/gitlab-becknik";
      };
    };
  };
}
