#!/usr/bin/env bash

function decode() { echo "${*}" | base64 --decode; }

export_file="${SRCROOT}/Flutter/DartDefines.xcconfig"

IFS=',' read -r -a dart_defines <<< "$DART_DEFINES"

: > "${SRCROOT}/Flutter/DartDefines.xcconfig"

for index in "${!dart_defines[@]}"
do
  dart_define=$(decode "${dart_defines[$index]}")
  if [[ $dart_define =~ ^APP_ ]]; then
    IFS='=' read -r -a key_value <<< "$dart_define"
    export ${key_value[0]}=${key_value[1]}
    echo "${key_value[0]}=${key_value[1]}" >> ${export_file}
  fi
done

# cp "$PROJECT_DIR/firebase_app_id_file_${APP_FLAVOR}.json" "$PROJECT_DIR/firebase_app_id_file.json"
# cp "$PROJECT_DIR/GoogleServices/GoogleService-Info_${APP_FLAVOR}.plist" "$PROJECT_DIR/Runner/GoogleService-Info.plist"