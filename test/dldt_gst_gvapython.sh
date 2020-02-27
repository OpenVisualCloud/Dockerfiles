#!/bin/bash -e

if (gst-inspect-1.0 gvapython)
then
  exit 0
else
  exit 1
fi
