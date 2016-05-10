# 引入package
gulp = require('gulp')
runSequence = require('run-sequence')
del = require('del')
uglify = require('gulp-uglify')
concat = require('gulp-concat')
minifyCss = require('gulp-minify-css')
#unCss = require('gulp-uncss')
browserSync = require('browser-sync').create()

# 获取参数


# 构建任务
gulp.task('default', (callback) ->
  runSequence(['clean'], ['build'], ['serve', 'watch'], callback)
)

gulp.task('clean', (callback)->
  del(['./app/dist/'], callback)
)

gulp.task('build', (callback) ->
  runSequence(['copy', 'miniJs', 'miniCss'], callback)
)

gulp.task('copy', ->
  gulp.src('./app/src/**/*.*')
  .pipe(gulp.dest('./app/dist/'));
)

gulp.task('miniJs', ->
  gulp.src('./app/src/**/*.js')
  .pipe(uglify())
  .pipe(gulp.dest('./app/dist/'))
)

gulp.task('miniCss', ->
  gulp.src('./app/src/**/*.css')
  .pipe(minifyCss())
  .pipe(concat('app.css', {newLine: ';\n\n'}))
  .pipe(gulp.dest('./app/dist/'))
)

gulp.task('concat', ->
  gulp.src('./app/src/**/*.js')
  .pipe(concat('all.js', {newLine: ';\n'}))
  .pipe(gulp.dest('./app/dist/'))
)

gulp.task('serve', ->
  browserSync.init({
    server: {
      baseDir: './app/dist/'
    }
    port:7411
  })
)

gulp.task('watch', ->
  gulp.watch('./app/src/**/*.*', ['reload'])
)

gulp.task('reload', (callback)->
  runSequence(['copy', 'miniJs', 'miniCss'],['reload-browser'], callback)
)

gulp.task('reload-browser', ->
  browserSync.reload();
)