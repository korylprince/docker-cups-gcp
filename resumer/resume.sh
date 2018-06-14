#!/bin/sh

for printer in $RESUME_PRINTERS; do
    cupsenable $printer
done
