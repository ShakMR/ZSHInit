#!/bin/zsh

verbose=0
all=0

# Parse arguments
while [ $# -gt 0 ]; do
  case "$1" in
    -v|--verbose)
      verbose=1
      ;;
    all)
      all=1
      ;;
    *)
      extension_name="$1"
      ;;
  esac
  shift
done

withLog() {
  if [ $verbose -eq 1 ]; then
    eval $1
  else
    eval $1 > /dev/null 2>&1
  fi
}

log() {
  if { [ $verbose -eq 1 ] && [ $1 = "DEBUG" ]; } || [ $1 = "INFO" ]; then
    shift
    echo $@
  fi
}

process() {
  log INFO -n $1 ⬜️
  eval $2 > /dev/null 2>&1
  log INFO -e "\r$1 ✅"
  sleep .5
}

writeChangelog() {
  temp_file=tmp.$$
  extension_name=$1
  version=$2
  source_changelog="src/${extension_name}/CHANGELOG.md"
  changelog_file="extensions/${extension_name}/CHANGELOG.md"

  log INFO -n "Enter changelog comment for version ${version}: "
  read -r changelog_comment

  echo """
## Version ${version}

$changelog_comment

---
  """ > $temp_file
  echo "" >> $temp_file
  cat "$source_changelog" >> $temp_file
  cp -f $temp_file "$source_changelog"
  mv -f $temp_file "$changelog_file"
}

bundle() {
  currentVersion=$(cat extensions/${1}/manifest.json | jq -r .version)
  log INFO -n "Current version for ${1} is $currentVersion. Enter new version: "
  read -r version

  #if version is empty use the current version
  if [ -z "$version" ]; then
    log DEBUG "\tUsing current version $currentVersion"
    version=$currentVersion
  else
    writeChangelog $1 $version
  fi

  # update version in manifest.json
  jq --arg version "$version" '.version = $version' extensions/${1}/manifest.json > tmp.$$.json && mv -f tmp.$$.json extensions/${1}/manifest.json

  process "Building ${1} version $version" "npm run build:dev"

  mkdir -p packed

  if [ -d extensions/$1 ]; then
    process "Packing extension ${1} $version" "rm -v -f packed/$1-$version.zip && (cd extensions && zip -v -r ../packed/$1-$version.zip $1 > /dev/null 2>&1)"
  else
    log INFO "Error: Extension with name $1 does not exist ❌"
  fi
}

# If all flag is set, bundle all extensions
if [ $all -eq 1 ]; then
  for extension in extensions/*; do
    bundle $(basename $extension)
  done
  exit
fi

# If extension_name is set, bundle the specified extension
if [ -n "$extension_name" ]; then
  bundle "${extension_name}"
else
  log INFO -n "Enter extension name: "
  read -r extension_name
  bundle "${extension_name}"
fi
