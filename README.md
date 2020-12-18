<!-- README.md is generated from README.Rmd. Please edit that file -->

# mockr

<!-- badges: start -->

[![rcc](https://github.com/krlmlr/mockr/workflows/rcc/badge.svg)](https://github.com/krlmlr/mockr/actions) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/mockr)](https://cran.r-project.org/package=mockr) [![Codecov test coverage](https://codecov.io/gh/krlmlr/mockr/branch/master/graph/badge.svg)](https://codecov.io/gh/krlmlr/mockr?branch=master)

<!-- badges: end -->

The goal of mockr is to provide a drop-in replacement for [`testthat::with_mock()`](https://testthat.r-lib.org/reference/with_mock.html) which is deprecated in testthat 3.0.0. The only exported function, `with_mock()`, is modeled closely after the original implementation, but now only allows mocking functions in the package under test. In contrast to the original implementation, no fiddling with R’s internals is needed, and the implementation plays well with byte-compiled code. There are some caveats, though:

1.  Mocking external functions (in other packages) doesn’t work anymore. This is by design.
    -   If you need to mock an external function, write a wrapper.
    -   If that external function is called by a third-party function, you’ll need to perhaps mock that third-party function, or look for a different way of implementing this test or organizing your code.
2.  You cannot refer to functions in your package via `your.package::` or `your.package:::` anymore, this is a limitation of the implementation.
    -   Remove the `your.package:::`, your code and tests should run just fine without that.

If you encounter other problems, please [file an issue](https://github.com/krlmlr/mockr/issues).

## Example

<pre class='chroma'>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://krlmlr.github.io/mockr/'>mockr</a></span><span class='o'>)</span>

<span class='nv'>some_func</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='o'>)</span> <span class='kr'><a href='https://rdrr.io/r/base/stop.html'>stop</a></span><span class='o'>(</span><span class='s'>"oops"</span><span class='o'>)</span>
<span class='nv'>some_other_func</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='o'>)</span> <span class='nf'>some_func</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'># Calling this function gives an error</span>
<span class='nf'>some_other_func</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; Error in some_func(): oops</span>

<span class='nv'>tester_func</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>{</span>
  <span class='c'># Here, we override the function that raises the error</span>
  <span class='nf'><a href='https://krlmlr.github.io/mockr/reference/local_mock.html'>with_mock</a></span><span class='o'>(</span>
    some_func <span class='o'>=</span> <span class='kr'>function</span><span class='o'>(</span><span class='o'>)</span> <span class='m'>42</span>,
    <span class='nf'>some_other_func</span><span class='o'>(</span><span class='o'>)</span>
  <span class='o'>)</span>
<span class='o'>}</span>

<span class='c'># No error raised</span>
<span class='nf'>tester_func</span><span class='o'>(</span><span class='o'>)</span>
<span class='c'>#&gt; [1] 42</span>

<span class='c'># Mocking overrides functions in the same environment, with a warning</span>
<span class='nf'><a href='https://krlmlr.github.io/mockr/reference/local_mock.html'>with_mock</a></span><span class='o'>(</span>some_func <span class='o'>=</span> <span class='kr'>function</span><span class='o'>(</span><span class='o'>)</span> <span class='m'>6</span> <span class='o'>*</span> <span class='m'>7</span>, <span class='nf'>some_other_func</span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Replacing functions in evaluation environment: `some_func()`</span>
<span class='c'>#&gt; [1] 42</span></pre>

## Installation

Install from CRAN via

<pre class='chroma'>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"mockr"</span><span class='o'>)</span></pre>

------------------------------------------------------------------------

## Code of Conduct

Please note that the mockr project is released with a [Contributor Code of Conduct](https://krlmlr.github.io/mockr/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
