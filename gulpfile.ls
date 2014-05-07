require! <[gulp gulp-util gulp-clean gulp-jade gulp-stylus path express gulp-livereload tiny-lr]>
gutil = gulp-util

lr-server = tiny-lr!

livereload = ->
  gulp-livereload lr-server


gulp.task 'clean' ->
  gulp.src '_public'
    .pipe gulp-clean!

gulp.task 'slides' ->

  gulp.src 'src/index.jade'
    .pipe gulp-jade pretty: 'yes'
    .pipe gulp.dest '_public'
    .pipe livereload!

gulp.task 'stylus' ->

  gulp.src 'src/css/app.styl'
    .pipe gulp-stylus!
    .pipe gulp.dest '_public/css'
    .pipe livereload!

gulp.task 'assets' ->
  gulp.src 'src/assets/**/*'
    .pipe gulp.dest '_public'
    .pipe livereload!

gulp.task 'vendor:js' ->

  gulp.src 'vendor/scripts/*.js'
    .pipe gulp.dest '_public/js'

gulp.task 'vendor:css' ->

  gulp.src 'vendor/styles/*.css'
    .pipe gulp.dest '_public/css'


gulp.task 'build' <[slides stylus vendor:css assets]>


gulp.task 'server' ->
  require! <[connect-livereload]>

  app = express!
  app.set 'port', 8080
  app.use connect-livereload!
  app.use express.static path.resolve '_public'

  app.listen app.settings.port, ->
    gutil.log 'Listen on ' + app.settings.port

gulp.task 'dev' <[build vendor:js server]> ->

  lr-server.listen 35729, ->
    return gutil.log it if it
  gulp.watch 'src/index.jade' <[slides]>
  gulp.watch 'src/css/*.styl' <[stylus]>
  gulp.watch 'src/assets/**/*' <[assets]>

gulp.task 'present' <[build]> ->
  Server = require 'impress-server'
  dir = path.resolve '_public'
  port = gutil.env.port or process.env.port or 8080
  password = gutil.env.password or process.env.password or '604a'
  server = new Server(dir, port, password)
  server.start!


gulp.task 'default' <[present]>
