# To-do

* Spec-compliant HTTP/1.1 HTTP server
* Listen on a TCP port, unix sock file, inetd, or connect to and receive connections from a hub
* Static file serving
* CGI responses
* Request forwarding for gateway/proxy use
* Support for TLS if stunnel is installed (maybe openssl)
	https://www.stunnel.org/static/stunnel.html#INETD-MODE
* Multithreading support (one fork per request)

Try some of these CGI scripts: https://gist.github.com/stokito/a9a2732ffc7982978a16e40e8d063c8f

Use sysread to write data: https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#Builtins

## Code Modules

### Arguments parsing

```
zhttpd
	[-c <config.conf>]
	[-p <port>]
	[--sock <file>]
	[--hub <host:port>]
	[-r <directory>]
	[-d]
```

### Logging

Log all requests to system console.

Offer a variety of logging formats, including Apache-compatible.

Offer a terminal-native logging format that shows multiple outstanding requests, spinners, progress bars, etc.

### Webarchive output format for logging

Log detailed requests to a .webarchive file for future inspection

## Listening Options

### `-p <port>`

Listen on TCP port number `<port>`.

### `--sock <sockfile>`

Listen on Unix sock file `<sockfile>`.

### `--hub <host:port>`

Connect to a load balancer or other gateway and receive HTTP requests from it.

### `--hub-key <file>`

Use the given TLS key to authenticate to the hub

## Routing/Serving Options

### `-d`

Enable debug mode; shows more sophisticated errors in the response as well as the console.

### `-c <config.conf>`

Load routes from <config.conf>.
For additional information, see `man zhttpd-conf`.

### `-d <directory>`

Serve files out of `<directory>`.
Set the Content-Type header depending on the patterns specified in `<ct>`.

### `--ct=os`

Try to resolve the content-type from the operating system's file extension tables. (Default)

### `--ct=none`

Don't use a builtin Content-Type table.

### `--ct=2025`

Use the default Content-Type list from Apache 2.4.

### `--ct <suffix>=<type>`

Serve files with filenames ending in <suffix> with `Content-Type: <type>`

## Configuration File

```
base = <http://example.com/> ; resolve relative URIs against this URI

# In the event of overlaps, the FIRST entry is evaluated

# Serve static files
route <http://localhost/file/{id}>
	serve = file
	file_root = .
	file_path = </file/{id}>

# Serve requests by running a command
route <http://localhost/user/{id}>
	serve = cgi_exec
	cgi_exe = /var/www/localhost/cgi-bin/user
	cgi_pathinfo = /{id}

# Specify an old-style cgi-bin you can run scripts from
route <http://localhost/cgi-bin/{filename}.cgi{/pathinfo*}>
	serve = cgi_exec
	cgi_exe = /var/www/localhost/cgi-bin/{filename}.cgi
	cgi_pathinfo = {/pathinfo*}

# Example for turning on a proxy to some-other-server
route <http://some-other-server/{+path}>
	serve = forward
	forward_inbound = some-other-server
    forward_path = {+path}

# Example for turning on a proxy to any server
route <http://{authority}/{+path}>
	serve = forward
	forward_inbound = {authority}
    forward_path = {+path}

# Serve a page describing the status of the server, logs, etc
route <http://localhost/about:status>
	serve = status

# Serve PHP files
route <http://localhost/{+file}.php>
	serve = cgi
	cgi_exe = /usr/bin/php
	cgi_pathinfo = /{+file}.php

# Forward request to clients connected on the given port
# If no clients are connected, this serves 503 Service Unavailable
route <http://localhost/{+file}.php>
	serve = hub
	hub_listen_port = 57456
	hub_request_form = origin-form
	hub_request_uri = http://localhost/{+file}.php
```

