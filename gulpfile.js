var gulp = require('gulp'),
  uglify = require('gulp-uglify'),
  concat = require('gulp-concat'),
  minifyCSS = require('gulp-minify-css');
  


gulp.task('build', ['buildcss'], function () {
  process.stdout.write("Minifying Javascript... (this may take a minute)\n");
  
    return gulp.src([
        'libraries/babylon.js/babylon.1.14.js',
        'libraries/knockout-3.3.0.js',
        'libraries/react/react-with-addons.js',
        'libraries/react/JSXTransformer.js',
        'libraries/alertify.js-0.3.11/lib/alertify.js',

        'libraries/loki-js/lokijs.js',
        'libraries/loki-js/loki-indexed-adapter.js',
        'libraries/loki-js/loki-trident-adapter.js',

        'libraries/prettyprint/prettyprint.js',
        'libraries/shortcut.js',
        'libraries/MetroJs.Full.0.9.74/MetroJs.js',
        'libraries/easeljs/easeljs-0.8.0.min.js',
        'libraries/pixi.js/pixi.js',
        'libraries/springy/springy.js',
        'libraries/springy/springyui.js',
        'libraries/obeliskjs/obelisk.js',
        'libraries/buckets/buckets-minified.js',
        'libraries/textillate/jquery.fittext.js',
        'libraries/textillate/jquery.lettering.js',
        'libraries/textillate/jquery.textillate.js',
        'libraries/filesaver/FileSaver.js',
        'libraries/indexed.js',
        'libraries/moment.min.js',
        'libraries/json-editor/jsoneditor.js',
        'libraries/d3/d3.min.js',
        'libraries/memory-stats.js',

        'scripts/sandbox-api.js',
        'scripts/tridentdb.js',
        'scripts/tridentlist.js',
        'scripts/workerpool.js'
    ])
    .pipe(uglify())
    .pipe(concat('sbx-bundle.min.js'))
    .pipe(gulp.dest('libraries/'));
});

gulp.task('buildcss', function () {
  process.stdout.write("Minifying CSS...\n");
  
  return gulp.src([
    'libraries/codemirror/lib/codemirror.css',
    'libraries/codemirror/addon/display/fullscreen.css',
    'libraries/codemirror/addon/dialog/dialog.css',
    'libraries/codemirror/addon/fold/foldgutter.css',
    'libraries/codemirror/addon/hint/show-hint.css',
    'libraries/codemirror/addon/lint/lint.css',
    'libraries/codemirror/theme/3024-day.css',
    'libraries/codemirror/theme/3024-night.css',
    'libraries/codemirror/theme/ambiance.css',
    'libraries/codemirror/theme/ambiance-mobile.css',
    'libraries/codemirror/theme/base16-dark.css',
    'libraries/codemirror/theme/base16-light.css',
    'libraries/codemirror/theme/blackboard.css',
    'libraries/codemirror/theme/cobalt.css',
    'libraries/codemirror/theme/colorforth.css',
    'libraries/codemirror/theme/eclipse.css',
    'libraries/codemirror/theme/elegant.css',
    'libraries/codemirror/theme/erlang-dark.css',
    'libraries/codemirror/theme/lesser-dark.css',
    'libraries/codemirror/theme/liquibyte.css',
    'libraries/codemirror/theme/mbo.css',
    'libraries/codemirror/theme/mdn-like.css',
    'libraries/codemirror/theme/midnight.css',
    'libraries/codemirror/theme/monokai.css',
    'libraries/codemirror/theme/neat.css',
    'libraries/codemirror/theme/neo.css',
    'libraries/codemirror/theme/night.css',
    'libraries/codemirror/theme/paraiso-dark.css',
    'libraries/codemirror/theme/paraiso-light.css',
    'libraries/codemirror/theme/pastel-on-dark.css',
    'libraries/codemirror/theme/rubyblue.css',
    'libraries/codemirror/theme/solarized.css',
    'libraries/codemirror/theme/the-matrix.css',
    'libraries/codemirror/theme/tomorrow-night-bright.css',
    'libraries/codemirror/theme/tomorrow-night-eighties.css',
    'libraries/codemirror/theme/ttcn.css',
    'libraries/codemirror/theme/twilight.css',
    'libraries/codemirror/theme/vibrant-ink.css',
    'libraries/codemirror/theme/xq-dark.css',
    'libraries/codemirror/theme/xq-light.css',
    'libraries/codemirror/theme/zenburn.css',

    'libraries/tinymce/skins/lightgray/skin.min.css',
    'libraries/textillate/animate.css',
    'libraries/MetroJs.Full.0.9.74/MetroJs.css',
    'libraries/jqplot/jquery.jqplot.css',
    'libraries/dynatree/skin/ui.dynatree.css',
    'libraries/jqGrid-4.5.4/css/ui.jqgrid.css',
    'libraries/alertify.js-0.3.11/themes/alertify.core.css',
    'libraries/alertify.js-0.3.11/themes/alertify.bootstrap.css',
    'libraries/font-awesome/css/font-awesome-abs.css'
    ])
    .pipe(minifyCSS())
    .pipe(concat('style-bundle.min.css'))
    .pipe(gulp.dest('css/'));
});

