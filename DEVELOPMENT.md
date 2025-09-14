

# Benchmarks

```
zhttpd --cgi tests/phpinfo.php
ab -c 10 -n 1000 http://127.0.0.1:8080/
```

On an Mac Studio M4 Max:

```
Server Software:        zhttpd/0.0.0
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /
Document Length:        97768 bytes

Concurrency Level:      10
Time taken for tests:   6.056 seconds
Complete requests:      1000
Failed requests:        103
   (Connect: 0, Receive: 0, Length: 103, Exceptions: 0)
Total transferred:      97948884 bytes
HTML transferred:       97767884 bytes
Requests per second:    165.12 [#/sec] (mean)
Time per request:       60.564 [ms] (mean)
Time per request:       6.056 [ms] (mean, across all concurrent requests)
Transfer rate:          15793.81 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    6  27.2      0     578
Processing:    46   54   2.6     53      66
Waiting:       42   49   2.5     49      61
Total:         46   60  27.3     54     628

Percentage of the requests served within a certain time (ms)
  50%     54
  66%     55
  75%     56
  80%     57
  90%     82
  95%     86
  98%    117
  99%    146
 100%    628 (longest request)
```

I'm not quite sure why I get Length exceptions.
