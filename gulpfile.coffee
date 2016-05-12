g = require 'gulp'
$ = do require 'gulp-load-plugins'
bs = require('browser-sync').create()
sc5 = require 'sc5-styleguide'
rimraf = require 'rimraf'
openurl = require 'openurl'

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
    plugin: 'js/plugin/*.js'
    dest: 'dest/js/'
  sc5:
    port: '3333'
    dest: 'sc5'

# ejs
g.task 'ejs', ->
  #JSON データ
  jsonData = require paths.ejs.json

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
  .pipe $.sass
    outputStyle: 'compressed'
  .pipe $.autoprefixer autoprefixer: '> 5%'
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
  g.src([in_path, paths.js.plugin])
  .pipe $.plumber()
  .pipe $.if(/[.]coffee$/, $.coffee())
  .pipe $.uglify mangle: ['jQuery']
  .pipe $.concat dest_file_name
  .pipe g.dest out_path
  .pipe $.filesize()

# coffee
g.task 'coffee', ->
  coffee_compile_process(paths.js.coffee, paths.js.dest)

# sc5
g.task 'styleguide:generate', ->
  g.src paths.css.sass
  .pipe sc5.generate
    title: 'SC5 Styleguide'
    server: true
    port: paths.sc5.port
    rootPath: paths.sc5.dest
    overviewPath: 'overview.md'
  .pipe g.dest paths.sc5.dest

g.task 'styleguide:applystyles', ->
  g.src paths.css.sass
  .pipe $.sass
    errLogToConsole: true
  .pipe sc5.applyStyles()
  .pipe g.dest paths.sc5.dest

g.task 'sc5', ['styleguide:generate', 'styleguide:applystyles']

# clean
g.task 'clean', (cb) ->
  rimraf paths.dest, cb

# browserSync
g.task 'bs', ->
  bs.init(null, {
    server:
      baseDir: 'dest'
  })

# build
g.task 'build', ['clean', 'ejs'], ->
  console.log 'build done!'

# test
g.task 'test', ->
  console.log 'this is testttttt'

# watch
g.task 'watch', ['sc5'], ->
  openurl.open 'http://localhost:' + paths.sc5.port

  g.watch paths.ejs.watch, ['ejs', bs.reload]
  g.watch paths.css.watch, ['css', bs.reload]
  g.watch [paths.js.coffee, paths.js.plugin], ['coffee', bs.reload]
  g.watch paths.css.watch, ['sc5']

# default
g.task 'default', ['bs', 'watch']