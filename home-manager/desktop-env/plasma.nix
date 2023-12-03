{ ... }:

{
  imports = [
    # sudo nix-channel --add https://github.com/pjones/plasma-manager/archive/trunk.tar.gz plasma-manager
  ];

  # TODO Grap the ones from my desktop
  programs.plasma.configFile = {
    kdeglobals = {
      "Colors:View".BackgroundNormal = "#2E2E2E";
      General.TerminalApplication = "gnome-terminal"; # Destroys nvim open files in dolphin
      KDE.ShowDeleteCommand = false;
    };

    okularrc = { };

    dolphinrc = {
      General = {
        ConfirmClosingMultipleTabs = false;
        RememberOpenedTabs = false;
        ShowSpaceInfo = false;
        UseTabForSwitchingSplitView = true;
      };
      ContentDisplay.UsePermissionsFormat = "NumericFormat";
      ContextMenu.ShowViewMode = false;
      DetailsMode.PreviewSize = 16;
      IconsMode.IconSize = 16;
      "KFileDialog Settings" = {
        "Places Icons Auto-resize" = false;
        "Places Icons Static Size" = 22;
      };
      VersionControl.enabledPlugins = "Git";
      Search.Location = "Everywhere";
      PreviewSettings."Plugins" = "appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,svgthumbnail,textthumbnail,ffmpegthumbs";
    };

    "kiorc" = {
      "Executable scripts".behaviourOnLaunch = "alwaysAsk";
      Confirmations = {
        ConfirmDelete = true;
        ConfirmEmptyTrash = true;
        ConfirmTrash = false;
      };
    };

    kservicemenurc.Show = {
      forgetfileitemaction = false;
      kactivitymanagerd_fileitem_linking_plugin = false;
      kio-admin = true;
      kompare = true;
      mountisoaction = true;
      nextclouddolphinactionplugin = true;
      sharefileitemaction = true;
      slideshowfileitemaction = true;
      tagsfileitemaction = true;
    };

    baloofilerc = {
      General.dbVersion = 2;
      "Basic Settings".Indexing-Enabled = false;
      #General."exclude filters version" = 8; # TODO wtf?
      #General."exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.venv,venv,core-dumps,lost+found";
    };
  };
}