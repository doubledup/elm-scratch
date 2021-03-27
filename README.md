# Elm scratch

Small Elm apps for learning the language. Includes some of the code from the
official [Elm Guide](https://guide.elm-lang.org/) for comparison.

## Running

As normal, either compile individual files with `elm make` and open the
generated `index.html` with a browser, or start up `elm reactor` and point your
browser at `localhost:8000`

Use `bin/build` to run the Webpack build. This takes files from public along
with `Main.elm`, compiles with the optimize flag and minifies & gzips the
result, storing it in `dist/`.

Alternatively, run `bin/optimize` to compile `Main.elm` only with the optimize
flag and minify & gzip the result, storing the it in `minify/`.
