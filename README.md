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

## gulp img
gulp.imageminで画像の最適化を行い、指定の場所に設置する

## gulp sc5_edit
sc5スタイルガイドを生成する
生成されるディレクトリは下記の通り。
`sc5_edit` local環境下での確認用
`gh-pages` このディレクトリをworktreeで登録して、gh-pagesブランチをpushすればgithub pagesにsc5スタイルガイドのページが作成されます。

### worktreeについて
worktreeは、ディレクトリ以下をブランチにすることができます。
例えばmasterブランチで作業したworktreeにした{worktreeディレクトリ}は通常通りのイメージです。
ここで`cd {worktreeディレクトリ}`とすると、そこは別ブランチになっています。
別ブランチではあるのですが、このブランチの中身と、masterブランチの{worktreeディレクトリ}の中身はリンクされ同じ状態になります。

### sc5スタイルガイドをgithub pagesにする方法

```bash
$ rm -D gh-pages # 「gh-pages」をworktree追加前にディレクトリが存在してはいけないので削除する
$ git checkout --orphan gh-pages  # 親なしのgh-pagesブランチを作成する
$ git reset --hard  # gh-pagesブランチの内容をリセットする
$ touch hoge  # 不要なファイルを用意する
$ git add .
$ git commit -am 'initial'
$ git worktree add gh-pages gh-pages
```

これで準備はできました、後はmasterブランチで更新を行い、gh-pagesに移動してpushすれば反映されます。
worktreeの場合ブランチの切り替えは`cd`で移動になります。

### なぜworktreeに追加したのか？
`git checkout -b gh-pages`としてアップした場合、不要なものまでgh-pagesにあがってしまいます。
そこで最低限の`gh-pages`ディレクトリをworktreeに追加してgithub pagesにあげています。

`sc5_edit`、`gh-pages`という２つのsc5スタイルガイドディレクトリが存在するのは
ローカル環境とgithub pagesでルートが異なる為になります。

## gulp clean
生成したdestディレクトリを削除する

## gulp build
ejsから生成したhtmlディレクトリを削除する

## gulp
下記の関係でを監視して、生成する
生成後ブラウザは自動でリロードされる。

|監視|生成|
--- | ---
|ejs|html|
|sass|css, sc5|
|coffeescript|js|

# gulp pluginのアップデート
npm-check-updates
https://www.npmjs.com/package/npm-check-updates

# ■TODO
`_header.ejs`、`_header_common.ejs`みたいな事になってきた場合、<br>
json側のデータを使って呼び出すか、テンプレート側で直接指定するかは方向性が決まっていないです。
