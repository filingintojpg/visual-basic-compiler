#!/bin/bash

set -e

BUILD_DIR="/build"
LEXER_CPP="$BUILD_DIR/lexer.cpp"
OUTPUT="$BUILD_DIR/VisualBasicCompiler"

mkdir -p "$BUILD_DIR"

echo "Generating lexer..."

flex --c++ \
    -o "$LEXER_CPP" \
    /app/lexer.l

echo "Compiling..."

SOURCES=$(find /app -name "*.cpp" -not -path "*/Debug/*" -not -path "*/Release/*")

g++ -std=c++20 \
    -I/app \
    -I/usr/include \
    $SOURCES \
    "$LEXER_CPP" \
    -o "$OUTPUT"

echo "Build successful!"
echo "Running..."
echo ""

"$OUTPUT" "$@"
