#!/bin/bash -ve

/opt/openssl/bin/openssl speed -engine qat -elapsed -async_jobs 72 rsa2048

