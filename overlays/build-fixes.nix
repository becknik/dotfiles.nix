{
  # Using the clean nixpkgs environment for huge packages

  don't-build-huge-packages = final: prev: {
    #thunderbird = prev.clean.thunderbird;
    webkitgtk = prev.clean.webkitgtk;

    ## GNOME
    webkitgtk_6_0 = prev.clean.webkitgtk_6_0;
    webkitgtk_4_1 = prev.clean.webkitgtk_4_1;

    ## Chromium
    electron = prev.clean.electron;
    electron_27 = prev.clean.electron_27;

    ## KDE
    spidermonkey = prev.clean.spidermondkey;

    ### Qt
    /*libsForQt5.qt5.override = {
                    qtwebview = prev.clean.libsForQt5.qt5.qtwebview;
                  };*/
    #qt6.qtwebview = prev.clean.qt6.qtwebview;
  };

  # Fixing Build Failures

  ## Reddis
  # test 66 failing: https://github.com/redis/redis/issues/12792
  deactivate-tests-redis = final: prev: {
    redis = prev.redis.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  };

  ## Python
  # Source: https://discourse.nixos.org/t/overwrite-the-disabledtests-of-a-failing-python-dependencies-in-nixos/36886
  deactivate-tests-failing-python = final: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (
        python-final: python-prev: {
          numpy = python-prev.numpy.overridePythonAttrs (oldAttrs: {
            disabledTests = [
              "test_validate_transcendentals"
              "test_structured_object_item_setting[<subarray>]"
            ] ++ oldAttrs.disabledTests;
          });
          curio = python-prev.curio.overridePythonAttrs (oldAttrs: {
            disabledTests = [
              "test_errors"
              "test_cpu"
            ] ++ oldAttrs.disabledTests;
          });
          eventlet = python-prev.eventlet.overridePythonAttrs (oldAttrs: {
            disabledTests = [
              "test_full_duplex"
              "test_invalid_connection"
              "test_nonblocking_accept_mark_as_reopened"
              "test_raised_multiple_readers"
              "test_recv_into_timeout"
            ] ++ oldAttrs.disabledTests;
          });
          pandas = python-prev.pandas.overridePythonAttrs (oldAttrs: {
            disabledTests = [
              "test_rolling_var_numerical_issues"
            ] ++ oldAttrs.disabledTests;
          });
        }
      )
    ];
  };

  ## Haskell
  # Source: https://unix.stackexchange.com/questions/497798/how-can-i-override-a-broken-haskell-package-in-nix
  deactivate-tests-haskell = final: prev: {
    haskellPackages = prev.haskellPackages.override {
      overrides = haskell-final: haskell-prev: {
        crypton = prev.haskell.lib.compose.dontCheck haskell-prev.crypton;
        crypton-x509-validation = prev.haskell.lib.compose.dontCheck haskell-prev.crypton-x509-validation;
        tls_1_9_0 = prev.haskell.lib.compose.dontCheck haskell-prev.tls_1_9_0;
        tls = prev.haskell.lib.compose.dontCheck haskell-prev.tls;

        #crypton = prev.haskell.lib.overrideCabal haskell-prev.crypton { doCheck = false; };
        #crypton = prev.haskell.lib.compose.overrideCabal (oldAttrs: {doCheck = false;}) prev.haskellPackages.crypton;
      };
    };
  };

}
