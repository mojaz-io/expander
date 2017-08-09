# Expander

> **A library to expand/unshorten urls with unified cache store.**

[hex]: https://hex.pm/packages/expander
[hex-version-badge]:   https://img.shields.io/hexpm/v/expander.svg?maxAge=86400&style=flat-square
[hex-downloads-badge]: https://img.shields.io/hexpm/dt/expander.svg?maxAge=86400&style=flat-square
[hex-license-badge]:   https://img.shields.io/badge/license-MIT-7D26CD.svg?maxAge=86400&style=flat-square

[docs]: https://inch-ci.org/github/mojaz-io/expander
[docs-badge]: https://inch-ci.org/github/mojaz-io/expander.svg?branch=master&style=flat-square

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

[master]: https://github.com/mojaz-io/expander/tree/master
[master-status]: https://img.shields.io/travis/mojaz-io/expander/master.svg?maxAge=86400&style=flat-square
[master-coverage]: https://img.shields.io/coveralls/mojaz-io/expander/master.svg?maxAge=86400&style=flat-square

[development]: https://github.com/mojaz-io/expander/tree/development
[development-status]: https://img.shields.io/travis/mojaz-io/expander/development.svg?maxAge=86400&style=flat-square
[development-coverage]: https://img.shields.io/coveralls/mojaz-io/expander/development.svg?maxAge=86400&style=flat-square

## Cache Adapters

Expander supports the following cache adapters. Below is the list of the adapters currently included:

Provider   | Expander adapter                | Dependancy
:----------| :-------------------------------| :----------
Local      | Expander.Cache.Adapter.Local    |
Redis      | Expander.Cache.Adapter.Redix    | {:redix, ">= 0.0.0"}
Memcache   | Expander.Cache.Adapter.Memcache | {:memcachex, ">= 0.0.0"}


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

