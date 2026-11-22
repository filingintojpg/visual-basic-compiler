#include "compiler/semantic/diagnostics.hpp"
#include <algorithm>
#include <cstdarg>
#include <cstdio>
#include <iostream>

static const char* kindName(ErrorKind kind) {
    switch (kind) {
        case ErrorKind::Name:     return "NAME ERROR";
        case ErrorKind::Type:     return "TYPE ERROR";
        case ErrorKind::Value:    return "VALUE ERROR";
        case ErrorKind::Flow:     return "FLOW ERROR";
        case ErrorKind::Codegen:  return "CODEGEN ERROR";
        case ErrorKind::Internal: return "INTERNAL ERROR";
    }
    return "SEMANTIC ERROR";
}

void Diagnostics::error(ErrorKind kind, int line, const char* format, ...) {
    char buffer[1024];
    va_list args;
    va_start(args, format);
    vsnprintf(buffer, sizeof(buffer), format, args);
    va_end(args);

    for (const Diagnostic& d : items) {
        if (d.kind == kind && d.line == line && d.message == buffer) return;
    }
    items.push_back({kind, line, buffer});
}

void Diagnostics::print() const {
    std::vector<Diagnostic> sorted = items;
    std::stable_sort(sorted.begin(), sorted.end(), [](const Diagnostic& a, const Diagnostic& b) { 
        return a.line < b.line; 
    });

    for (const Diagnostic& d : sorted) {
        std::cerr << kindName(d.kind) << " at line " << d.line << ": " << d.message << "\n";
    }
}
