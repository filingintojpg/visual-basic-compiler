#!/bin/bash

set -e

BUILD_DIR="/build"
LEXER_CPP="/app/lexer/lexer.cpp"
OUTPUT="$BUILD_DIR/VisualBasicCompiler"

mkdir -p "$BUILD_DIR"
rm -f "$LEXER_CPP"

echo "Generating lexer..."

flex --c++ \
    -o "$LEXER_CPP" \
    /app/lexer/lexer.l

echo "Compiling..."

SOURCES=$(find /app -name "*.cpp" -not -path "*/Debug/*" -not -path "*/Release/*")

g++ -std=c++20 \
    -I/app \
    -I/usr/include \
    $SOURCES \
    -o "$OUTPUT"

echo "Build successful!"
echo "Running..."
echo ""

"$OUTPUT" "$@"
