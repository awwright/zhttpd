
# zHTTPd: HTTP server written in zsh

A self-contained Web/HTTP server designed for static files, proxying/inspecting traffic, and supporting CGI and FastCGI.

It is entirely self-contained in a single file, and guaranteed to work out of the box in all macOS systems.

Features:

* Spec-compliant HTTP/1.1 HTTP server
* Listen on a TCP port, unix sock file, inetd, or connect to and receive connections from a hub
* Static file serving
* CGI responses
* Request forwarding for gateway/proxy use
* Support for TLS if stunnel is installed (maybe openssl)

## Usage

zhttpd
	[-p <port>]
	[-d <directory>]
