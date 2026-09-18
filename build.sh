#!/bin/bash
set -e

cmake -S /app -B /build
cmake --build /build

echo ""
/build/VisualBasicCompiler "$@"
