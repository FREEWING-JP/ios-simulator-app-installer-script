#!/bin/sh

# ios-simulator-app-installer-script
# http://www.neko.ne.jp/~freewing/
# Copyright (c)2017 FREE WING, Y.Sakamoto
# https://github.com/FREEWING-JP/ios-simulator-app-installer-script
#
# chmod +x app_installer.sh
# ./app_installer.sh

# APP_NAME="Hoge Fuga"で "Hoge Fuga.app"ファイル
# APP_NAME="*"で最新の appファイル
APP_NAME="*"
APP_EXT="app"
# APP_BUNDLE_ID指定でアプリのアンインストールと自動起動が可能になる
# APP_BUNDLE_ID="test.app.Hoge-Fuga"
APP_BUNDLE_ID=""
# UNINSTALL="YES"でアンインストールを行なう（要 APP_BUNDLE_ID指定）
UNINSTALL=""
# 実行対象のシミュレータ名称
SIMLATOR_NAME="iPhone X (11.0.1)"
# 以下は固定値で変更しない事
DEVICES_DIR=~/Library/Developer/CoreSimulator/Devices/
APPLICATION_DIR=/data/Containers/Bundle/Application

# シミュレータ一覧を取得して、SIMLATOR_NAMEと同じ名前のデバイス IDを取り出す
echo .
echo ${SIMLATOR_NAME}
SIMLATOR_TARGET=`xcrun instruments -s | grep "${SIMLATOR_NAME} \["`
echo .
echo ${SIMLATOR_TARGET}
SIMLATOR_TARGET=`echo ${SIMLATOR_TARGET} | grep -o -e "\[.*\]"`
SIMLATOR_TARGET_ID=`echo ${SIMLATOR_TARGET} | cut -b 2-37`
echo ${SIMLATOR_TARGET_ID}

# シミュレータのデバイス IDを指定してシミュレータを起動する
xcrun_instruments_cmd=`echo ${SIMLATOR_TARGET} | grep -o -e "\[.*\]" | xargs -I {} echo xcrun instruments -w '"{}"'`

# デバッグした直後は該当のシミュレータのフォルダのタイムスタンプが更新される
# findコマンドで最新のシミュレータのフォルダを検索して取得する
FIND_DIR1=`stat -l -t '%FT%T' ${DEVICES_DIR}* | grep -e "^d.*\$" | sort -k 6 | tail -1`
echo .
echo ${FIND_DIR1}
FIND_DIR1=`echo ${FIND_DIR1} | cut -d " " -f 7`
ls -l ${FIND_DIR1}${APPLICATION_DIR}
echo .

echo SEARCH: "${APP_NAME}.${APP_EXT}"
if [ "${APP_NAME}" = "*" ]; then
  # 最新のシミュレータのフォルダから、対象のアプリのフォルダを検索する
  # statコマンドで対象のアプリのフォルダを列挙して日付でソートして最新を取得する
  FIND_DIR2=`echo ${FIND_DIR1} | xargs -I {} stat -l -t '%FT%T' {}${APPLICATION_DIR} | grep -e "^d.*\$" | sort -k 6 | tail -1`
  echo ${FIND_DIR2}
  # アプリのフォルダからアプリのファイル名を取得する
  FIND_DIR3=`echo ${FIND_DIR2} | cut -d " " -f 7-`
  APP_FILE=`find ${FIND_DIR3} -name ${APP_NAME}.${APP_EXT}`
else
  # APP_NAMEの指定が有る場合は {$APP_NAME}.{$APP_EXT}のファイル名で最新の物を取得する
  # findコマンドで対象のファイルを検索して取得する
  FIND_DIR2=`echo ${FIND_DIR1} | xargs -I {} find {}${APPLICATION_DIR} -maxdepth 2 -name "${APP_NAME}.${APP_EXT}" | xargs -I {} stat -l -t '%FT%T' {} | sort -k 6 | tail -1`
  echo ${FIND_DIR2}
  APP_FILE=`echo ${FIND_DIR2} | cut -d " " -f 7-`
fi
echo "${APP_FILE}"

# シミュレータのデバイス IDを指定してシミュレータを起動する
echo .
echo ${xcrun_instruments_cmd}
${xcrun_instruments_cmd}

# UNINSTALLが "YES"で APP_BUNDLE_IDの指定が有る場合はアンインストールする
if [ "${UNINSTALL}" = "YES" ]; then
  if [ -n "${APP_BUNDLE_ID}" ]; then
    xcrun simctl uninstall ${SIMLATOR_TARGET_ID} ${APP_BUNDLE_ID}
  fi
fi

# 対象のアプリを指定して、シミュレータにインストールする
ls -l "${APP_FILE}"
echo xcrun simctl install booted "${APP_FILE}"
xcrun simctl install booted "${APP_FILE}"

# APP_BUNDLE_IDの指定が有る場合はインストール後に自動起動する
if [ -n "${APP_BUNDLE_ID}" ]; then
  xcrun simctl launch booted ${APP_BUNDLE_ID}
fi
