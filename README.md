# meme

**meme** - A memegen.link ruby client.

## Introduction

**meme** generate memes by a phrase or configurable details.

## Installation

    $ gem build
    $ gem install -g
    $ gem install meme-$(ruby -Ilib -e 'require "meme/version"; puts Meme::VERSION').gem

## Usage

For usage of command line tool `meme` see following help output.

    Usage:
        meme [OPTIONS] SUBCOMMAND [ARG] ...

    Parameters:
        SUBCOMMAND          subcommand
        [ARG] ...           subcommand arguments

    Subcommands:
        aag                 Ancient Aliens Guy
        ackbar              It's A Trap!
        afraid              Afraid to Ask Andy
        ...
        zero-wing           All Your Base Are Belong to Us

    Options:
        -m, --man           show manpage
        -v, --version       show version
        -h, --help          print help

For API documentation use `rake doc`.

## License

[MIT License](https://spdx.org/licenses/MIT.html).

## Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434)
