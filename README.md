# Developer enVironment Manager

## Installation


Note: `dvm` works only when bash and curl or wget are available

### Install script

To install you could use the [install script][2] using cURL:

    curl -o- https://raw.githubusercontent.com/luisepifanio/dvm/0.0.17/install.sh | bash

or Wget:

    wget -qO- https://raw.githubusercontent.com/luisepifanio/dvm/0.0.17/install.sh | bash

<sub>
The script clones the dvm repository to `~/.dvm` and adds the source line to your profile (`~/.bash_profile`, `~/.zshrc` or `~/.profile`).</sub>

<sub>*NB. The installer can use `git`, `curl`, or `wget` to download `nvm`, whatever is available.*</sub>

### Manual install

TBC

To activate nvm, you need to source it from your shell:

    . ~/.dvm/dvm.sh

I always add this line to my `~/.bashrc`, `~/.profile`, or `~/.zshrc` file to have it automatically sourced upon login.
Often I also put in a line to use a specific version of node.

## Usage

  For now just configures your development environment to quick start, but it is not production ready

  curl -o- https://raw.githubusercontent.com/luisepifanio/dvm/0.0.17/install.sh | bash

## License

nvm is released under the MIT license.


Copyright (C) 2010-2014 Luis Epifanio

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
