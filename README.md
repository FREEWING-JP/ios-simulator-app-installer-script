# ios-simulator-app-installer-script
iPhoneの .app形式のアプリファイルを抜き出して、指定したシミュレータで実行する補助スクリプト

## FREE WING Homepage
http://www.neko.ne.jp/~freewing/

---
## 使い方

1. app_installer.shファイルをダウンロードして、ターミナルで実行出来る様に実行権限を付与する。
2. app_installer.shファイルの中の APP_NAMEや SIMLATOR_NAMEを適宜書き換える。
3. XCode上で目的のアプリをシミュレータで実行する。
4. app_installer.shをターミナルで実行する。

---
## 目的

* 古い XCodeでビルドしているアプリを最新のシミュレータで動かしたい場合。
　アプリの .appファイルを取り出して、シミュレータに食わせたい。

---
## 動作原理

　XCodeの端末シミュレータと実行アプリケーションは下記のフォルダ構成で格納されます。  
~/Library/Developer/CoreSimulator/Devices/{SIMULATOR DEVICE ID}/data/Containers/Bundle/Application/{APPLICATION ID}  

　XCode上でシミュレータを起動してアプリを実行した場合に、シミュレータのディレクトリ ~/Library/Developer/CoreSimulator/Devices/{SIMULATOR DEVICE ID}のデバイス IDのディレクトリのタイムスタンプと、デバイス ID配下の /data/Containers/Bundle/Application/{APPLICATION ID}のアプリケーション IDのタイムスタンプが更新されます。  

このシェルスクリプトは最新の {SIMULATOR DEVICE ID}ディレクトリ配下の最新の .appファイルを検索し、それを目的のシミュレータにインストールする動作を自動で行ないます。  

