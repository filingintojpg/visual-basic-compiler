#!/bin/bash
# Builds the compiler, runs it on a .vb file and renders the parse tree to SVG.
# Runs inside the container (see docker-compose.yml, service "ast").
#
# Usage: ast.sh <file.vb> [output.svg]
# Default output: ast-visualizer/<file name>.svg in the project directory.
set -uo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: docker compose run --rm ast <file.vb> [output.svg]" >&2
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$1"
if [ ! -f "$src" ]; then
    echo "File not found: $src (path is relative to the project root)" >&2
    exit 1
fi

name="$(basename "${src%.*}")"
out="${2:-${script_dir}/output/${name}.svg}"
out_dir="$(dirname "$out")"
mkdir -p "$out_dir"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# 1. Build
if ! { cmake -S /app -B /build && cmake --build /build; } >"$tmp/build.log" 2>&1; then
    cat "$tmp/build.log" >&2
    echo "Build failed" >&2
    exit 1
fi

# 2. Run the parser: bison debug trace goes to stderr
/build/VisualBasicCompiler "$src" >/dev/null 2>"$tmp/trace.txt"
code=$?
if [ $code -ne 0 ]; then
    cat "$tmp/trace.txt" >&2
    echo "Compiler exited with code $code" >&2
    exit $code
fi

if grep -q "syntax error" "$tmp/trace.txt"; then
    echo "Warning: the parser reported a syntax error, the tree may be incomplete" >&2
fi

# 3. Trace -> dot -> svg
  python3 "$script_dir/script.py" "$tmp/trace.txt" >"$tmp/tree.dot" || exit 1
dot -Tsvg "$tmp/tree.dot" -o "$out" || exit 1

# Hand the files back to the host user (matters on Linux hosts, where the container runs as root)
chown --reference=/app "$out_dir" "$out" 2>/dev/null || true

echo "AST saved to: ${out#/app/}"
