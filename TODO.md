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

### `--stdio`

Read STDIN and respond on STDOUT. Logs are written to STDERR. For use with inetd and similar programs.

### `--hub <host:port>`

Connect to a load balancer or other gateway and receive HTTP requests from it.

Hubs typically listen on 175 (one-byte compliment of 80) or 57456 (two-byte compliment of 8080).

### `--hub-key <file>`

Use the given TLS key to authenticate to the hub

## File Serving Options

### `--fileroot <path>`

Serve file out of the given `<path>`

### `--filedefault=<filename>`

If the resource is a directory, serve `<filename>` out of that directory.

### `--filelisting`

If the resource is a directory, provide a listing of the files in the directory. `--filedefault` takes precedence, if that file exists.

## CGI Routing Options

### `--cgi-prefix=<uri>`

Call the CGI for URIs beginning with the given path

### `--cgi=<filepath>`

Execute the file at the given `<filepath>` to respond to the request.
Sends CGI environment variables for request headers and reads headers in STDOUT for the response.

### `--cgi-env=<env>`

Call the given CGI with the provivded environment variable. e.g. `zhttpd --cgi=/bin/php-cgi --cgi-env=CONF=/etc/program.ini`

### `--cgi-arg=<arg>`

Call the CGI given from the last `--cgi` argument with the given `<arg>` as an argument. May be specified multiple times as necessary.

## Custom Routing Options

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
	cgi_exe = /usr/bin/php-cgi
	cgi_env = CONFIG_PATH=/etc/foo.conf
	cgi_pathinfo = /{+file}.php

# Forward request to clients connected on the given port
# If no clients are connected, this serves 503 Service Unavailable
route <http://localhost/{+file}.php>
	serve = hub
	hub_listen_port = 57456
	hub_request_form = origin-form
	hub_request_uri = http://localhost/{+file}.php
```

## Listening Modes

### Load Balancer/Gateway Hub

Usage:

```
./zhttpd \
	--hub hub.example.com:175 \
	--hub-key client.key
```

Connect to a load balancer and receive requests through that connection.

Offer plaintext modes, TLS modes, and client-authenticated TLS modes.

Automatically make a new connection.

### TLS configuration

- Support listening on a TLS connection.
- Automatically create a TLS certificate, if necessary.
- Save the genrated TLS certificate to system certificate store, if desired
- Get certificate signed by the appropriate authorities, if possible

## Reverse Tunnel

A reverse tunnel lets you host applications on a computer behind a firewall, and connect to the load balancer from behind the firewall.

One instance runs next to the origin to act as the hub, and one instance runs from behind the NAT firewall.

### Origin-side, inbound configuration

On the side behind the firewall:

```
./zhttpd \
	--hub hub.example.com:175 \
	--hub-key client.key \
	--pass-gateway localhost:8080
```

This will connect to the hub, then forward all requests received from the hub along to the origin server at localhost:8080.

### User/gateway-side, outbound configuraton

```
./zhttpd \
	--port 80
	--pass-hub hub.example.com:175
```

This will setup a normal HTTP server on port 80, and a hub at port 175, then forward requests to origins connected on port 175.

You can also use this command with inetd, xinetd, or launchd.
Investigate of SO_REUSEPORT works so that multiple connections can be made.

```
# Run this for connections to port 175 or 57456
# This will open a listener for HTTP connections on port 8080
./zhttpd \
	--port 8080
	--hub-stdio
	--hub-key client.key
```
