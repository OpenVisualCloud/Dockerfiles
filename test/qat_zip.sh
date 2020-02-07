#!/bin/bash -ve

dd if=/dev/urandom bs=115200 count=10 of=test.log # some log
/opt/intel/QATzip/bin/qzip test.log
test -e test.log.gz

