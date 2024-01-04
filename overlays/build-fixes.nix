system:

{
  # Using the clean nixpkgs environment for huge packages

  dependency-build-skip = final: prev: {
    webkitgtk = prev.clean.webkitgtk;
    webkitgtk_6_0 = prev.clean.webkitgtk_6_0;
    webkitgtk_4_1 = prev.clean.webkitgtk_4_1;

    ## Chromium
    electron = prev.clean.electron;
    electron_27 = prev.clean.electron_27;
    #qtwebengine =

    ## Compiler
    gfortran = prev.clean.gfortran; # why is this even a dependency?!
    #clang = prev.clean.clang;
    #llvm = prev.clean.llvm;

    #spidermonkey = prev.clean.spidermondkey;
    #thunderbird = prev.clean.thunderbird;
    # Not working:
    #libsForQt5.qt5.override = { qtwebview = prev.clean.libsForQt5.qt5.qtwebview; };
    /* qt6Packages = prev.qt6Packages.override {
      overrides = (qt-final: qt-prev: {
        qt6.qtwebview = qt-prev.clean.qt6.qtwebview;
        qt6.qtwebengine = qt-prev.clean.qt6.qtwebengine;
      });
    }); */
    #qt6.qtwebview = prev.clean.qt6.qtwebview;
    #qt6.qtwebengine = prev.clean.qt6.qtwebengine;
  };

  # Fixing Build Failures

  ## Reddis
  # test 66 failing: https://github.com/redis/redis/issues/12792
  deactivate-failing-tests-normal-packages = final: prev: {
    redis = prev.redis.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  };

  ## Python
  # Source: https://discourse.nixos.org/t/overwrite-the-disabledtests-of-a-failing-python-dependencies-in-nixos/36886
  deactivate-failing-tests-python = final: prev: {
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
          afdko = python-prev.afdko.overridePythonAttrs (oldAttrs: {
            disabledTests = [
              "test_alt_missing_glyph"
            ] ++ oldAttrs.disabledTests;
          });
        }
      )
    ];
  };

  ## Haskell
  # Source: https://unix.stackexchange.com/questions/497798/how-can-i-override-a-broken-haskell-package-in-nix
  deactivate-failing-tests-haskell = final: prev: {
    haskellPackages = prev.haskellPackages.override {
      overrides = haskell-final: haskell-prev: {
        crypton = prev.haskell.lib.compose.dontCheck haskell-prev.crypton;
        crypton-x509-validation = prev.haskell.lib.compose.dontCheck haskell-prev.crypton-x509-validation;
        tls_1_9_0 = prev.haskell.lib.compose.dontCheck haskell-prev.tls_1_9_0;
        tls = prev.haskell.lib.compose.dontCheck haskell-prev.tls;

        # Getting GHCup and running for haskell.haskell vscode extension...
        /*         haskus-utils-variant = (import
          (builtins.fetchGit {
            name = "nixpkgs-unstable-haskus-utils-variant-3.2.1";
            url = "https://github.com/NixOS/nixpkgs/";
            ref = "refs/heads/nixpkgs-unstable";
            rev = "6e3a86f2f73a466656a401302d3ece26fba401d9";
          })
          { inherit system; }).haskellPackages.haskus-utils-variant;
        yaml-streamly = (import # libyaml-streamly is broken
          (builtins.fetchGit {
            name = "nixpkgs-unstable-libyaml-streamly-0.2.1";
            url = "https://github.com/NixOS/nixpkgs/";
            ref = "refs/heads/nixpkgs-unstable";
            rev = "50a7139fbd1acd4a3d4cfa695e694c529dd26f3a";
          })
          { inherit system; }).haskellPackages.yaml-streamly;
        cabal-plan = (import
          (builtins.fetchGit {
            name = "nixpkgs-unstable-cabal-plan-0.7.2.3";
            url = "https://github.com/NixOS/nixpkgs/";
            ref = "refs/heads/nixpkgs-unstable";
            rev = "50a7139fbd1acd4a3d4cfa695e694c529dd26f3a";
          })
          { inherit system; }).haskellPackages.cabal-plan; */
      };
    };
  };
}
