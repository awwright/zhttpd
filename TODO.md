# To-do

* Spec-compliant HTTP/1.1 HTTP server
* Listen on a TCP port, unix sock file, inetd, or connect to and receive connections from a hub
* Static file serving
* CGI responses
* Request forwarding for gateway/proxy use
* Support for TLS if stunnel is installed (maybe openssl)
* Multithreading support (one fork per request)

## Code Modules

### Arguments parsing

```
zhttpd
	[-c <config.conf>]
	[-p <port>]
	[--sock <file>]
	[--hub <host:port>]
	[-d <directory>]
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

# Serve static files
<http://localhost/file/{id}>
	serve = file
	file_root = .
	file_path = </file/{id}>

# Serve requests by running a command
<http://localhost/user/{id}>
	serve = cgi_exec
	cgi_exe = /var/www/localhost/cgi-bin/user
	cgi_pathinfo = /{id}

# Specify an old-style cgi-bin you can run scripts from
<http://localhost/cgi-bin/{filename}.cgi{/pathinfo*}>
	serve = cgi_exec
	cgi_exe = /var/www/localhost/cgi-bin/{filename}.cgi
	cgi_pathinfo = {/pathinfo*}

# Example for turning on a proxy to some-other-server
http://some-other-server/{+path}
	serve = forward
	forward_inbound = some-other-server
    forward_path = {+path}

# Example for turning on a proxy to any server
http://{authority}/{+path}
	serve = forward
	forward_inbound = {authority}
    forward_path = {+path}
```

