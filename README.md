
# zHTTPd: HTTP server written in zsh

a.k.a. awwright-zhttpd

A self-contained Web/HTTP server designed to run out of the box on macOS.

Features:

* Spec-compliant HTTP/1.1 HTTP server
* Listen on a TCP port, unix sock file, inetd, or connect to and receive connections from a hub
* Static file serving
* CGI responses
* Request forwarding for gateway/proxy use
* Support for TLS if stunnel is installed (maybe openssl)

## Usage

```
zhttpd --help
zhttpd --version
zhttpd [--port <port>]
```

## Installation

### Quick Install of Questionable Security

Should work on most systems:

> $ sudo curl -L -o /usr/local/bin/zhttpd https://raw.githubusercontent.com/awwright/zhttpd/refs/heads/master/zhttpd && sudo chmod +x /usr/local/bin/zhttpd

### Development install

> git clone https://github.com/awwright/zhttpd.git && cd zhttpd
> sudo ln -s zhttpd /usr/local/bin/zhttpd

## Examples

### Gitweb

This works on macOS with Git installed from Homebrew. For other systems, you will need to configure the path to the cgi:

zhttpd --cgi /System/Volumes/Data/opt/homebrew/share/gitweb/gitweb.cgi
