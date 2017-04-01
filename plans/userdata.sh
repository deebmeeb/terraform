#!/bin/bash
echo "Hello again, World" > index.html
nohup busybox httpd -f -p 8080 &
