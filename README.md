# ■ejsよるHTML開発スタートキット
自分用です(´・ω・`)

## 特徴

- ejs => html の生成ができる
- sass => cssの生成ができる
- coffeescript =>o jsの生成ができる
- sc5スタイルガイドの生成ができる
- browser syncで自動リロードできる
- browser syncがサーバを立ち上げるので、このリポジトリで完結できる

html生成の設定は、json側に埋め込むよう意識しました。
※ejsやgulpに書いてしまうと耐久性さがりそうだったので。
json側で、テンプレート、設置場所を指定できるので、自分で使う分には将来性はそこそこ担保できたかなと思っています。

# ■インストール
※node.jsなどは予め準備しておいてください。

`npm install`

# ■ejsの使い方

## pages.json
`ejs/pages.json`で生成したいページを指定する

```pages.json:json
  {
    "template": "./ejs/home.ejs",
    "url": "index.html",
    "page_category": "page_home",
    "title": "これはタイトルです",
    "keywords": "これはキーワードです",
    "description": "これはディスクリプションです"
  }
```

### template
指定したパスをテンプレートとして使います

### url
指定したパスでhtmlを出力します
※重複していた場合、後のもので上書きされます

### page_category
ページカテゴリごとにclassを付与することで、耐久性を担保しようと思い用意しました。

## 参考URL
### 公式
https://github.com/mde/ejs

### 参考
テンプレートエンジンEJSで使える便利な構文まとめ
http://qiita.com/y_hokkey/items/31f1daa6cecb5f4ea4c9

# ■Gulp
作業しやすいようにgulpfile.coffeeを書き換えてください。

私が作業しやすい初期状態になってます。

## gulp ejs
ejsからhtmlを生成する

## gulp css
sassを生成する

## gulp coffee
coffeescriptを生成する

## gulp sc5
sc5スタイルガイドを生成する

## gulp clean
ejsから生成したhtmlフォルダを削除する

## gulp
下記の関係でを監視して、生成する
生成後ブラウザは自動でリロードされる。

|監視|生成|
--- | ---
|ejs|html|
|sass|css, sc5|
|coffeescript|js|

# ■TODO
`_header.ejs`、`_header_common.ejs`みたいな事になってきた場合、<br>
json側のデータを使って呼び出すか、テンプレート側で直接指定するかは方向性が決まっていないです。