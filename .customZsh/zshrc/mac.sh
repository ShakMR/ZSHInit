defaultBrowser() {
  if [[ "$(uname)" != "Darwin" ]]; then
    echo "defaultBrowser only works on macOS"
    return 1
  fi

  local browser="${1:l}"
  local target
  local bundle_id

  case "${browser}" in
    "")
      local current=$(defaults read ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers 2>/dev/null | awk 'BEGIN{entry=""} /^    \}/{if (entry ~ /LSHandlerURLScheme = http;/) {split(entry, lines, "\n"); for (i in lines) if (lines[i] ~ /^        LSHandlerRoleAll = /) {print tolower(lines[i]); exit}} entry=""; next} {entry=entry $0 "\n"}' | awk '{print $3}' | tr -d '";')
      [[ "${current}" == *firefox* ]] && target="chrome" || target="firefox"
      ;;
    chrome|google-chrome|googlechrome)
      target="chrome"
      ;;
    firefox|ff)
      target="firefox"
      ;;
    *)
      echo "Usage: defaultBrowser [chrome|firefox]"
      return 1
      ;;
  esac

  case "${target}" in
    chrome)
      bundle_id="com.google.Chrome"
      ;;
    firefox)
      bundle_id="org.mozilla.firefox"
      ;;
  esac

  if command -v defaultbrowser >/dev/null 2>&1; then
    defaultbrowser "${target}" && return
  fi

  local set_status=$(BROWSER_BUNDLE_ID="${bundle_id}" osascript -l JavaScript -e 'ObjC.import("CoreServices"); const app = Application.currentApplication(); app.includeStandardAdditions = true; const bundleId = $(app.systemAttribute("BROWSER_BUNDLE_ID")); const http = $.LSSetDefaultHandlerForURLScheme($("http"), bundleId); const https = $.LSSetDefaultHandlerForURLScheme($("https"), bundleId); `${http},${https}`;' 2>/dev/null)

  if [[ "${set_status}" == "0,0" ]]; then
    echo "Default browser set to ${target}"
    return
  fi

  case "${target}" in
    chrome)
      open -a "Google Chrome" --args --make-default-browser
      ;;
    firefox)
      open -a "Firefox" --args --setDefaultBrowser
      ;;
  esac

  echo "Asked ${target} to become the default browser"
  echo "Launch Services status: ${set_status:-unknown}"
}
