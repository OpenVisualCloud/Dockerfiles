#!/bin/bash -ve

/usr/local/ssl/bin/openssl speed -engine qatengine -elapsed -async_jobs 72 rsa2048

