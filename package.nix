{
  lib,
  stdenvNoCC,
  fetchurl,
  ffmpeg-headless,
  kdePackages,
  # image or video, the extension decides how the theme plays it
  background ? fetchurl {
    url = "https://github.com/PandeCode/nixutils/raw/refs/heads/media/sddm/factorio.mp4";
    sha256 = "0hrj4x8q068ih398gcjsr7ai6qb7mlj8mbdgcdqjcm98pjbchvaj";
  },
  # image shown while a video background loads, defaults to its first frame
  placeholder ? null,
  # keys from theme.conf, they override its defaults
  themeConfig ? { },
}:

let
  extension =
    file: lib.strings.toLower (lib.lists.last (lib.strings.splitString "." (baseNameOf file)));

  images = [
    "png"
    "jpg"
    "jpeg"
    "webp"
    "gif"
  ];
  videos = [
    "avi"
    "mp4"
    "mov"
    "mkv"
    "m4v"
    "webm"
  ];

  backgroundExt = extension background;
  isVideo = lib.lists.elem backgroundExt videos;
  placeholderExt = if placeholder == null then "png" else extension placeholder;

  # sddm skips empty values in the .user file, so only set what exists
  quote = v: builtins.toJSON (if lib.isBool v then lib.boolToString v else toString v);
  userConfig = lib.generators.toINI { mkKeyValue = k: v: "${k}=${quote v}"; } {
    General = {
      Background = "Backgrounds/background.${backgroundExt}";
    }
    // lib.attrsets.optionalAttrs isVideo {
      BackgroundPlaceholder = "Backgrounds/placeholder.${placeholderExt}";
    }
    // themeConfig;
  };

  themeDir = "$out/share/sddm/themes/foundry";
in

assert lib.assertMsg (lib.lists.elem backgroundExt (images ++ videos))
  "sddm-foundry-theme: background must be one of ${
    lib.strings.concatStringsSep ", " (images ++ videos)
  }, got '${backgroundExt}'";
assert lib.assertMsg (placeholder == null || lib.lists.elem placeholderExt images)
  "sddm-foundry-theme: placeholder must be one of ${lib.strings.concatStringsSep ", " images}, got '${placeholderExt}'";

stdenvNoCC.mkDerivation {
  pname = "sddm-foundry-theme";
  version = "1.0.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Main.qml
      ./components
      ./fonts
      ./metadata.desktop
      ./theme.conf
    ];
  };

  nativeBuildInputs = lib.lists.optional (isVideo && placeholder == null) ffmpeg-headless;

  dontBuild = true;
  dontWrapQtApps = true;

  propagatedBuildInputs = with kdePackages; [
    qtdeclarative
    qtmultimedia
  ];

  inherit userConfig;
  passAsFile = [ "userConfig" ];

  installPhase = ''
    runHook preInstall

    mkdir -p ${themeDir}/Backgrounds
    cp -r ./* ${themeDir}

    cp ${background} ${themeDir}/Backgrounds/background.${backgroundExt}
    ${
      if !isVideo then
        ""
      else if placeholder == null then
        "ffmpeg -loglevel error -i ${background} -frames:v 1 ${themeDir}/Backgrounds/placeholder.png"
      else
        "cp ${placeholder} ${themeDir}/Backgrounds/placeholder.${placeholderExt}"
    }

    # sddm reads theme.conf.user on top of theme.conf
    cp $userConfigPath ${themeDir}/theme.conf.user

    runHook postInstall
  '';

  meta = {
    description = "SDDM theme of factory game";
    homepage = "https://github.com/PandeCode/sddm-foundry-theme";
    platforms = lib.platforms.linux;
  };
}
