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

[![Version][hex-version-badge]][hex]
[![Downloads][hex-downloads-badge]][hex]
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

Expander supports the following cache adapters:

Provider   | Expander adapter                | Dependancy
:----------| :-------------------------------| :----------
Local      | Expander.Cache.Adapter.Local    |
Redis      | Expander.Cache.Adapter.Redix    | {:redix, ">= 0.0.0"}
Memcache   | Expander.Cache.Adapter.Memcache | {:memcachex, ">= 0.0.0"}
ETS        | Expander.Cache.Adapter.ETS      |

## Getting Started

```elixir
# In your config/config.exs file
config :sample, Sample.Expander,
  adapter: Expander.Cache.Adapter.Local

# In your application code
defmodule Sample.Expander do
  use Expander.Expand, otp_app: :sample
end

defmodule Sample.Url do
  import Expander.Url

  def generate(url) do
    new
    |> short_url(url)
  end
end

# In an IEx session
Sample.Url.generate("http://stpz.co/haddafios") |> Sample.Expander.expand

```

## Installation

1. Add expander to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:expander, "~> 0.0.1"}]
    end
    ```
2. (Optional - only for Elixir < 1.4) Ensure expander is started before your application:

    ```elixir
    def application do
      [applications: [:expander]]
    end
    ```
3. (Optional) If you are using `Expander.Cache.Adapter.Redix` or `Expander.Cache.Adapter.Memcache`, you also need to add these dependencies to your deps and list of applications:

    ```elixir
    # You only need to do this if you are using Elixir < 1.4
    def application do
      [applications: [:expander, :redix]]
    end

    def deps do
      [{:expander, "~> 0.0.1"},
       {:redix, ">= 0.0.0"}]
    end

    ##  OR

    # You only need to do this if you are using Elixir < 1.4
    def application do
      [applications: [:expander, :memcachex]]
    end

    def deps do
      [{:expander, "~> 0.0.1"},
       {:memcachex, ">= 0.0.0"}]
    end
    ```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/expander](https://hexdocs.pm/expander).

