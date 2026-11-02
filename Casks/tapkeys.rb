cask "tapkeys" do
  version "0.2.0"
  sha256 "bf30168234c2ccb9a2458b10b24ecef75363f3e6bd8fdf118fcd84a19133c98e"

  url "https://github.com/scharfff/tapkeys/releases/download/v#{version}/TapKeys-v#{version}.zip"
  name "TapKeys"
  desc "Trackpad gestures that trigger keyboard shortcuts, from the menu bar"
  homepage "https://github.com/scharfff/tapkeys"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "TapKeys.app"

  uninstall quit: "io.github.scharfff.tapkeys"

  zap trash: "~/Library/Preferences/io.github.scharfff.tapkeys.plist"

  caveats <<~EOS
    TapKeys is not notarized (ad hoc signature, no Apple Developer ID), so macOS
    blocks the first launch. To allow it, either:

      1. Open TapKeys, close the warning, then go to System Settings,
         Privacy & Security, scroll down and click "Open Anyway".
         (On macOS 15 and newer right-click, Open no longer works.)
      2. Or remove the quarantine flag yourself:
           xattr -dr com.apple.quarantine "#{appdir}/TapKeys.app"

    Then grant Accessibility access (System Settings, Privacy & Security,
    Accessibility). The ad hoc signature changes with every release, so after
    `brew upgrade` macOS may ask for this access again: remove the old TapKeys
    entry from the list and add it back.
  EOS
end
