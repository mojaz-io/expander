# Expander

> **A library to expand/unshorten urls with unified cache store.**

[docs]: https://inch-ci.org/github/mojaz-io/expander
[docs-badge]: https://inch-ci.org/github/mojaz-io/expander.svg?branch=master&style=flat-square
[hex-license-badge]:   https://img.shields.io/badge/license-MIT-7D26CD.svg?maxAge=86400&style=flat-square

[deps]: https://beta.hexfaktor.org/github/mojaz-io/expander
[deps-badge]: https://beta.hexfaktor.org/badge/all/github/mojaz-io/expander.svg?branch=master&style=flat-square

[![License][hex-license-badge]][hex]
[![Dependencies][deps-badge]][deps]
[![Documentation][docs-badge]][docs]

## Synopsis

`Expander` aims to help you:

  - Expand short urls
  - Experiment with different key/value cache store backends for the shortened urls
  - Allow end-users of your library liberty to choose their preferred backend

## Status

|         :thumbsup:         |  [Continuous Integration][status]   |        [Test Coverage][coverage]         |
|:--------------------------:|:-----------------------------------:|:----------------------------------------:|
|      [Master][master]      |   ![Build Status][master-status]    |   ![Coverage Status][master-coverage]    |
| [Development][development] | ![Build Status][development-status] | ![Coverage Status][development-coverage] |

[status]: https://travis-ci.org/mojaz-io/expander
[coverage]: https://coveralls.io/github/mojaz-io/expander





## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `expander` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:expander, "~> 0.0.1"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/expander](https://hexdocs.pm/expander).

