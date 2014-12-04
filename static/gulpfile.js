var gulp        = require('gulp'),
    less        = require('gulp-less'),
    concat      = require('gulp-concat'),
    ngAnnotate  = require('gulp-ng-annotate'),
    sourcemaps  = require('gulp-sourcemaps'),
    streamqueue = require('streamqueue');

var conf = require('./build.json');

const DEST  = gulp.dest(conf['dest']);
const CSS   = 'app.css';
const JS    = 'app.js';

function ext(ext) {
  var re = new RegExp('\.%s$'.replace('%s', ext))
  return function(value) {
    return value.match(re);
  }
}

function panic(e) {
  console.log("\u0007%s".replace('%s', e.toString()));
}

gulp.task('js', function() {
  return gulp.src(conf[JS])
    .on('error', panic)
    .pipe(sourcemaps.init())
    .pipe(concat(JS))
    .pipe(sourcemaps.write())
    .pipe(DEST)

});

gulp.task('css', function() {
  var _css  = conf[CSS].filter(ext('css')),
      _less = conf[CSS].filter(ext('less'));

  return streamqueue({objectMode: true},
      gulp.src(_css),
      gulp.src(_less)
        .on('error', panic)
        .pipe(less())
    )
    .pipe(sourcemaps.init())
    .pipe(concat(CSS))
    .pipe(sourcemaps.write())
    .pipe(DEST);
});

gulp.task('default', ['js', 'css'], function() {
  gulp.watch()
});
