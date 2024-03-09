{ inputs, ... }:

final: prev: {
  efivar = prev.clean.efivar;
  #esl-iter.c:84:1: error: conflicting types for 'esl_iter_next_with_size_correction' due to enum/integer mismatch; have 'esl_iter_status_t(esl_iter *, efi_guid_t *, efi_guid_t *, uint8_t **, size_t *, _Bool)' {aka 'enum esl_iter_status(esl_iter *, efi_guid_t *, efi_guid_t *, unsigned char **, long unsigned int *, _Bool)'} [-Werror=enum-int-mismatch]
  # 84 | esl_iter_next_with_size_correction(esl_iter *iter, efi_guid_t *type,

  criu = prev.clean.criu;
  # In file included from criu/include/cr_options.h:7,
  #                  from criu/mount.c:13:
  # In function '__list_add',
  #     inlined from 'list_add' at include/common/list.h:41:2,
  #     inlined from 'mnt_tree_for_each' at criu/mount.c:1966:2:
  # include/common/list.h:35:19: error: storing the address of local variable 'postpone' in '((struct list_head *)((char *)start + 8))[24].prev' [-Werror=dangling-pointer=]
  #    35 |         new->prev = prev;
  #       |         ~~~~~~~~~~^~~~~~

  tesseract4 = prev.clean.tesseract4;
  # In file included from points.cpp:24:
  # ../../src/ccutil/helpers.h:40:17: error: 'uint64_t' has not been declared
  #    40 |   void set_seed(uint64_t seed) {
  #       |                 ^~~~~~~~
  # ../../src/ccutil/helpers.h:71:3: error: 'uint64_t' does not name a type
  #    71 |   uint64_t seed_{1};
  #       |   ^~~~~~~~
  # ../../src/ccutil/helpers.h:29:1: note: 'uint64_t' is defined in header '<cstdint>'; did you forget to '#include <cstdint>'?
  #    28 | #include <string>
  #   +++ |+#include <cstdint>
  #    29 |
  # ../../src/ccutil/helpers.h: In member function 'void tesseract::TRand::set_seed(int)':
  # ../../src/ccutil/helpers.h:41:5: error: 'seed_' was not declared in this scope; did you mean 'seed'?
  #    41 |     seed_ = seed;
  #       |     ^~~~~
  #       |     seed
  # ../../src/ccutil/helpers.h: In member function 'void tesseract::TRand::set_seed(const std::string&)':
  # ../../src/ccutil/helpers.h:46:26: error: 'uint64_t' does not name a type
  #    46 |     set_seed(static_cast<uint64_t>(hasher(str)));
  #       |                          ^~~~~~~~
  # ../../src/ccutil/helpers.h:46:26: note: 'uint64_t' is defined in header '<cstdint>'; did you forget to '#include <cstdint>'?
  # ../../src/ccutil/helpers.h: In member function 'int32_t tesseract::TRand::IntRand()':
  # ../../src/ccutil/helpers.h:52:12: error: 'seed_' was not declared in this scope; did you mean 'seed48'?
  #    52 |     return seed_ >> 33;
  #       |            ^~~~~
  #       |            seed48
  # ../../src/ccutil/helpers.h: In member function 'double tesseract::TRand::SignedRand(double)':
  # ../../src/ccutil/helpers.h:56:38: error: 'INT32_MAX' was not declared in this scope
  #    56 |     return range * 2.0 * IntRand() / INT32_MAX - range;
  #       |                                      ^~~~~~~~~
  # ../../src/ccutil/helpers.h:56:38: note: 'INT32_MAX' is defined in header '<cstdint>'; did you forget to '#include <cstdint>'?
  # ../../src/ccutil/helpers.h: In member function 'double tesseract::TRand::UnsignedRand(double)':
  # ../../src/ccutil/helpers.h:60:32: error: 'INT32_MAX' was not declared in this scope
  #    60 |     return range * IntRand() / INT32_MAX;
  #       |                                ^~~~~~~~~
  # ../../src/ccutil/helpers.h:60:32: note: 'INT32_MAX' is defined in header '<cstdint>'; did you forget to '#include <cstdint>'?
  # ../../src/ccutil/helpers.h: In member function 'void tesseract::TRand::Iterate()':
  # ../../src/ccutil/helpers.h:66:5: error: 'seed_' was not declared in this scope; did you mean 'seed48'?
  #    66 |     seed_ *= 6364136223846793005ULL;
  #       |     ^~~~~
  #       |     seed48

  intel-compute-runtime = prev.clean.intel-compute-runtime;
  # criptor.h:267:28:
  # /nix/store/d7fv3mxcdqklwlfvk5bvzmgqqfsd5blb-gcc-13.2.0/include/c++/13.2.0/bits/stl_algobase.h:398:11: error: '*(unsigned char (*)[7]
  # )((char*)&<unnamed> + offsetof(NEO::ArgDescValue, NEO::ArgDescValue::elements.StackVec<NEO::ArgDescValue::Element, 1, unsigned char>
  # ::onStackMemRawBytes[0]))' may be used uninitialized [-Werror=maybe-uninitialized]
  #   398 |         { *__to = *__from; }
  #       |           ^

  pdfslicer = prev.clean.pdfslicer;
  # In file included from /build/source/third-party/range-v3/include/range/v3/range_fwd.hpp:20,
  #                  from /build/source/third-party/range-v3/include/range/v3/algorithm/adjacent_find.hpp:16,
  #                  from /build/source/third-party/range-v3/include/range/v3/algorithm.hpp:20,
  #                  from /build/source/src/application/zoomlevel.cpp:18:
  # /build/source/third-party/range-v3/include/meta/meta.hpp:3165:19: error: declaration of 'template<class Fn> template<class State, class A> using meta::detail::partition_<Fn>::invoke = meta::_t<meta::detail::partition_<Fn>::impl<State, A> >' changes meaning of 'invoke' [-Wchanges-meaning]
  #  3165 |             using invoke = _t<impl<State, A>>;


  # Deactivating tests

  tzdata = prev.tzdata.overrideAttrs (oldAttrs: {
    checkTarget = "check_back check_character_set check_white_space check_links check_name_lengths check_slashed_abbrs check_sorted check_tables check_ziguard check_zishrink check_tzs";
    # Not backported to 23.11 yet: https://github.com/artemist/nixpkgs/commit/24b2d1bdf3ec321b6f4039bf6f348a064597cfd8
    #checkTarget = builtins.replaceStrings [ "check_now " ] [ "" ] oldAttrs.checkTarget; # TODO why doesn't this work?

    # zones Asia/Almaty and Asia/Tashkent identical from now on
    # make: *** [Makefile:944: check_now] Error 1
  });
  /*   bind = prev.bind.overrideAttrs (_oldAttrs: {
    doCheck = false;
    # [ RUN      ] isc_random_bytes_binarymatrixrank
    # [  ERROR   ] --- p_value_t >= 0.0001
    # [   LINE   ] --- random_test.c:391: error: Failure!
    # [  FAILED  ] isc_random_bytes_binarymatrixrank
  }); */

  redis = prev.redis.overrideAttrs (_oldAttrs: { doCheck = false; });
  # TODO Not backported to 23.11 yet: https://github.com/SuperSandro2000/nixpkgs/commit/5cd9b0a6ba85d41061779de6b11d0d079cda0804
  # test 66 failing due to: https://github.com/redis/redis/issues/12792

  #[exception]: Executing test client: permission denied.
  #while executing "close $fd" (procedure "set_oom_score_adj" line 7) invoked from within
  #"set_oom_score_adj 22" ("uplevel" body line 3) invoked from within
  #"uplevel 1 $code" (procedure "test" line 58) invoked from within
  #"test {CONFIG SET oom score restored on disable} { r config set oom-score-adj no set_oom_score_adj 22 assert_equal ..." ("uplevel" body line 98) invoked from within
  #"uplevel 1 $code " (procedure "start_server" line 3) invoked from within
  #"start_server {tags {"oom-score-adj external:skip"}} { proc get_oom_score_adj {{pid ""}} { if {$pid == ""} { set pi..." (file "tests/unit/oom-score-adj.tcl" line 5) invoked from within
  #"source $path" (procedure "execute_test_file" line 4) invoked from within
  #"execute_test_file $data" (procedure "test_client_main" line 10) invoked from within
  #"test_client_main $::test_server_port "

  libsecret = prev.libsecret.overrideAttrs (_oldAttrs: { doCheck = false; });
  # [7-24/24] 🌓 libsecret:secret-tool / test-secret-tool.sh                  0s^M 7/24 libsecret:libsecret / test-prompt
  #     FAIL            0.12s   killed by signal 6 SIGABRT
  # >>> LD_LIBRARY_PATH=/build/libsecret-0.21.3/build/libsecret ASAN_OPTIONS=halt_on_error=1:abort_on_error=1:print_summary=1 UBSAN_OPTI
  # ONS=halt_on_error=1:abort_on_error=1:print_summary=1:print_stacktrace=1 MALLOC_PERTURB_=145 /build/libsecret-0.21.3/build/libsecret/
  # test-prompt
  #  ✀
  # stdout:
  # TAP version 13
  # # random seed: R02S5ce3d10b7e27b82a155d61a4090ec07a
  # 1..12
  # # Start of prompt tests
  # # GLib-GIO-DEBUG: Using cross-namespace EXTERNAL authentication (this will deadlock if server is GDBus < 2.73.3)
  # not ok /prompt/run - libsecret:ERROR:../libsecret/test-prompt.c:133:test_perform_run: assertion failed (value > 0): (0 > 0)
  # Bail out!
  # stderr:
  # **
  # libsecret:ERROR:../libsecret/test-prompt.c:133:test_perform_run: assertion failed (value > 0): (0 > 0)

  texlive = prev.clean.texlive;
  # texlive-dvisvgm.bin-2022.drv:
  # In file included from Bitmap.cpp:24:
  # Bitmap.hpp:42:23: error: 'uint8_t' does not name a type
  #    42 |                 const uint8_t* rowPtr (int row) const {return &_bytes[row*_bpr];}
  #       |                       ^~~~~~~
  # Bitmap.hpp:26:1: note: 'uint8_t' is defined in header '<cstdint>'; did you forget to '#include <cstdint>'?
  #    25 | #include <vector>
  #   +++ |+#include <cstdint>
  #    26 |
  # Bitmap.hpp:65:29: error: 'uint8_t' was not declared in this scope
  #    65 |                 std::vector<uint8_t> _bytes;
  #       |                             ^~~~~~~
  # Bitmap.hpp:65:29: note: 'uint8_t' is defined in header '<cstdint>'; did you forget to '#include <cstdint>'?
  # Bitmap.hpp:65:36: error: template argument 1 is invalid
  #    65 |                 std::vector<uint8_t> _bytes;
  #       |                                    ^
  # Bitmap.hpp:65:36: error: template argument 2 is invalid
  # Bitmap.hpp: In member function 'bool Bitmap::empty() const':
  # Bitmap.hpp:48:92: error: request for member 'empty' in '((const Bitmap*)this)->Bitmap::_bytes', which is of non-class type 'const int'
  #    48 |                 bool empty () const                   {return (!_rows && !_cols) || _bytes.empty();}
  #       |                                                                                            ^~~~~
  # Bitmap.hpp: In member function 'int Bitmap::copy(std::vector<T>&, bool) const':
  # Bitmap.hpp:83:56: error: invalid types 'const int[int]' for array subscript
  #    83 |                         T chunk = static_cast<T>(_bytes[r*_bpr+b]) << (8*(s-1-b%s));
  #       |                                                        ^
  # Bitmap.cpp: In member function 'void Bitmap::resize(int, int, int, int)':
  # Bitmap.cpp:46:16: error: request for member 'resize' in '((Bitmap*)this)->Bitmap::_bytes', which is of non-class type 'int'
  #    46 |         _bytes.resize(_rows*_bpr);
  #       |                ^~~~~~
  # Bitmap.cpp:47:26: error: request for member 'begin' in '((Bitmap*)this)->Bitmap::_bytes', which is of non-class type 'int'
  #    47 |         std::fill(_bytes.begin(), _bytes.end(), 0);
  #       |                          ^~~~~
  # Bitmap.cpp:47:42: error: request for member 'end' in '((Bitmap*)this)->Bitmap::_bytes', which is of non-class type 'int'
  #    47 |         std::fill(_bytes.begin(), _bytes.end(), 0);
  #       |                                          ^~~
  # Bitmap.cpp: In member function 'void Bitmap::setBits(int, int, int)':
  #
  # --snip--

  librewolf-wayland = prev.clean.librewolf-wayland;
  thunderbird = prev.clean.thunderbird;
  # error: Package ‘gnum4-1.4.19’ in /nix/store/3i3rncs75fid9hwai5p2nvwc4ngdnia7-source/pkgs/development/tools/misc/gnum4/default.nix:33 is not available on the requested hostPlatform:
  #          hostPlatform.config = "wasm32-unknown-wasi"

  ## Python
  # Source: https://discourse.nixos.org/t/overwrite-the-disabledtests-of-a-failing-python-dependencies-in-nixos/36886
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_pFinal: pPrev: {
      numpy = pPrev.numpy.overridePythonAttrs (oldAttrs: {
        disabledTests = [
          "test_validate_transcendentals"
        ] ++ oldAttrs.disabledTests;
      });
      curio = pPrev.curio.overridePythonAttrs (oldAttrs: {
        disabledTests = [
          "test_cpu"
        ] ++ oldAttrs.disabledTests;
      });
      eventlet = pPrev.eventlet.overridePythonAttrs (oldAttrs: {
        disabledTests = [
          "test_full_duplex"
          "test_invalid_connection"
          "test_nonblocking_accept_mark_as_reopened"
          "test_raised_multiple_readers"
          "test_recv_into_timeout"
        ] ++ oldAttrs.disabledTests;
      });
      pandas = pPrev.pandas.overridePythonAttrs (oldAttrs: {
        disabledTests = [
          "test_rolling_var_numerical_issues"
        ] ++ oldAttrs.disabledTests;
      });
      paperwork-backend = pPrev.paperwork-backend.overridePythonAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];

  ## Haskell
  # Source: https://unix.stackexchange.com/questions/497798/how-can-i-override-a-broken-haskell-package-in-nix
  haskellPackages = prev.haskellPackages.override {
    overrides = hFinal: hPrev: {
      # Probably pandoc deps
      crypton = prev.haskell.lib.compose.dontCheck hPrev.crypton;
      crypton-x509-validation = prev.haskell.lib.compose.dontCheck hPrev.crypton-x509-validation;
      tls_1_9_0 = prev.haskell.lib.compose.dontCheck hPrev.tls_1_9_0;
      tls = prev.haskell.lib.compose.dontCheck hPrev.tls;
    };
  };
}
