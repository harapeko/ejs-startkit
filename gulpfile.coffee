g = require 'gulp'
$ = do require 'gulp-load-plugins'
fs = require 'fs'
bs = require('browser-sync').create()
sc5 = require 'sc5-styleguide'
rimraf = require 'rimraf'
openurl = require 'openurl'
doiuse = require 'doiuse'
autoprefixer = require 'autoprefixer'
mqpacker = require 'css-mqpacker'

# paths
paths =
  dest: 'dest'
  ejs:
    json: './ejs/pages.json'
    watch: ['ejs/*.ejs', 'ejs/**/*.ejs']
  css:
    sass: 'sass/app.sass'
    dest: 'dest/css'
    watch: ['sass/*.sass', 'sass/**/*.sass']
  js:
    coffee: 'js/coffee/*.coffee'
    jquery: 'js/jquery/*.js'
    plugin: 'js/plugin/*.js'
    dest: 'dest/js'
  img:
    src: 'img/**/*'
    dest: 'dest/img/'
  sc5:
    port: '3333'
    edit: 'sc5_edit'
    dest: 'gh-pages'
    app_root: '/ejs-startkit'

# target browsers
target_browsers = [
  '> 5%',
]

# ejs
g.task 'ejs', ->
  #JSON データ
  jsonData = JSON.parse fs.readFileSync(paths.ejs.json)

  jsonData.forEach (page, i) ->
    g.src page.template
    .pipe $.plumber()
    .pipe $.ejs(pageData: page)
    .pipe $.rename page.url
    .pipe g.dest paths.dest

# sass compile process
# string in_path         入力ディレクトリ
# string out_path        出力ディレクトリ
# string dest_file_name  出力ファイル名
sass_compile_process = (in_path, out_path, dest_file_name = 'app.css') ->
  g.src in_path
  .pipe $.plumber()
  .pipe $.sass()
  #.pipe $.autoprefixer autoprefixer: '> 5%'
  .pipe $.postcss([
    doiuse(browsers: target_browsers),
    autoprefixer(browsers: target_browsers),
    mqpacker
  ])
  .pipe $.csso()
  .pipe $.concat dest_file_name
  .pipe g.dest out_path
  .pipe $.filesize()

# css
g.task 'css', ->
  sass_compile_process(paths.css.sass, paths.css.dest)

# coffee compile process
# string in_path         入力ディレクトリ
# string out_path        出力ディレクトリ
# string dest_file_name  出力ファイル名
coffee_compile_process = (in_path, out_path, dest_file_name = 'app.js') ->
  g.src([paths.js.jquery, paths.js.plugin, in_path])
  .pipe $.plumber()
  .pipe $.if(/[.]coffee$/, $.coffee())
  .pipe $.uglify mangle: ['jQuery']
  .pipe $.concat dest_file_name
  .pipe g.dest out_path
  .pipe $.filesize()

# coffee
g.task 'coffee', ->
  coffee_compile_process(paths.js.coffee, paths.js.dest)

# sc5 edit
g.task 'sc5_edit', ->
  g.src paths.css.sass
  .pipe sc5.generate
    title: 'SC5 Styleguide edit'
    server: true
    port: paths.sc5.port
    rootPath: paths.sc5.edit
    overviewPath: 'overview.md'
  .pipe g.dest paths.sc5.edit

  g.src paths.css.sass
  .pipe $.sass
    errLogToConsole: true
  .pipe sc5.applyStyles()
  .pipe g.dest paths.sc5.edit


# sc5 github page
g.task 'gh', ->
  g.src paths.css.sass
  .pipe sc5.generate
    title: 'SC5 Styleguide'
    appRoot: paths.sc5.app_root
    overviewPath: 'overview.md'
  .pipe g.dest paths.sc5.dest

  g.src paths.css.sass
  .pipe $.sass
    errLogToConsole: true
  .pipe sc5.applyStyles()
  .pipe g.dest paths.sc5.dest


# img optimize
g.task 'img', ->
  g.src paths.img.src
  .pipe $.imagemin()
  .pipe g.dest paths.img.dest

# clean
g.task 'clean', (cb) ->
  rimraf paths.dest, cb

# browserSync
g.task 'bs', ->
  bs.init(null, {
    server:
      baseDir: 'dest'
    reloadDelay: 120
  })

# build
g.task 'build', ['ejs', 'css', 'coffee', 'img'], ->
  console.log 'build done!'

# test
g.task 'test', ->
  console.log 'this is testttttt'

# watch
g.task 'watch', ['sc5_edit'], ->
  openurl.open 'http://localhost:' + paths.sc5.port

  g.watch [paths.ejs.watch, paths.ejs.json], ['ejs', bs.reload]
  g.watch paths.css.watch, ['css', bs.reload]
  g.watch [paths.js.coffee, paths.js.jquery, paths.js.plugin], ['coffee', bs.reload]
  g.watch paths.css.watch, ['sc5_edit']
  g.watch paths.img.src, ['img']

# default
g.task 'default', ['bs', 'watch']
