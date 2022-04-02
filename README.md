<!-- README.md is generated from README.Rmd. Please edit that file -->

# mockr

<!-- badges: start -->

[![rcc](https://github.com/krlmlr/mockr/workflows/rcc/badge.svg)](https://github.com/krlmlr/mockr/actions) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/mockr)](https://cran.r-project.org/package=mockr) [![Codecov test coverage](https://codecov.io/gh/krlmlr/mockr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/krlmlr/mockr?branch=main)

<!-- badges: end -->

The goal of mockr is to provide a drop-in replacement for [`testthat::local_mock()`](https://testthat.r-lib.org/reference/with_mock.html) and [`testthat::with_mock()`](https://testthat.r-lib.org/reference/with_mock.html) which is deprecated in testthat 3.0.0. The functions [`mockr::local_mock()`](https://krlmlr.github.io/mockr/reference/local_mock.html) and [`mockr::with_mock()`](https://krlmlr.github.io/mockr/reference/local_mock.html) are modeled closely after the original implementation, but now only allow mocking functions in the package under test. In contrast to the original implementation, no fiddling with R’s internals is needed, and the implementation plays well with byte-compiled code. There are some caveats, though:

1.  Mocking external functions (in other packages) doesn’t work anymore. This is by design.
    -   If you need to mock an external function, write a wrapper.
    -   If that external function is called by third-party code, you’ll need to perhaps mock that third-party code, or look for a different way of implementing this test or organizing your code.
2.  You cannot refer to functions in your package via `your.package::` or `your.package:::` anymore.
    -   Remove the `your.package:::`, your code and tests should run just fine without that.

If you encounter other problems, please [file an issue](https://github.com/krlmlr/mockr/issues).

## Example

<pre class='chroma'>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://krlmlr.github.io/mockr/'>mockr</a></span><span class='o'>)</span>

<span class='nv'>access_resource</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>{</span>
  <span class='nf'><a href='https://rdrr.io/r/base/message.html'>message</a></span><span class='o'>(</span><span class='s'>"Trying to access resource..."</span><span class='o'>)</span>
  <span class='c'># For some reason we can't access the resource in our tests.</span>
  <span class='kr'><a href='https://rdrr.io/r/base/stop.html'>stop</a></span><span class='o'>(</span><span class='s'>"Can't access resource now."</span><span class='o'>)</span>
<span class='o'>}</span>

<span class='nv'>work_with_resource</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>{</span>
  <span class='nv'>resource</span> <span class='o'>&lt;-</span> <span class='nf'>access_resource</span><span class='o'>(</span><span class='o'>)</span>
  <span class='nf'><a href='https://rdrr.io/r/base/message.html'>message</a></span><span class='o'>(</span><span class='s'>"Fetched resource: "</span>, <span class='nv'>resource</span><span class='o'>)</span>
  <span class='nf'><a href='https://rdrr.io/r/base/invisible.html'>invisible</a></span><span class='o'>(</span><span class='nv'>resource</span><span class='o'>)</span>
<span class='o'>}</span>

<span class='c'># Calling this function gives an error</span>
<span class='nf'>work_with_resource</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; Trying to access resource...</span>
<span class='c'>#&gt; Error in access_resource(): Can't access resource now.</span>

<span class='nf'><a href='https://rdrr.io/r/base/eval.html'>local</a></span><span class='o'>(</span><span class='o'>{</span>
  <span class='c'># Here, we override the function that raises the error</span>
  <span class='nf'><a href='https://krlmlr.github.io/mockr/reference/local_mock.html'>local_mock</a></span><span class='o'>(</span>access_resource <span class='o'>=</span> <span class='kr'>function</span><span class='o'>(</span><span class='o'>)</span> <span class='m'>42</span><span class='o'>)</span>

  <span class='c'># No error raised</span>
  <span class='nf'>work_with_resource</span><span class='o'>(</span><span class='o'>)</span>
<span class='o'>}</span><span class='o'>)</span>
<span class='c'>#&gt; Fetched resource: 42</span></pre>

## Installation

Install from CRAN via

<pre class='chroma'>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"mockr"</span><span class='o'>)</span></pre>

------------------------------------------------------------------------

## Code of Conduct

Please note that the mockr project is released with a [Contributor Code of Conduct](https://krlmlr.github.io/mockr/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
