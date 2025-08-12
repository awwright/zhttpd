
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
