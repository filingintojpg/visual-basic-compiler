#pragma once
#include <string>
#include <vector>

enum class ErrorKind {
    Name,      // name is not declared, declared twice, no such member, no access to member
    Type,      // incompatible types, inappropriate arguments
    Value,     // invalid value or usage (assignment to constant, Me in Shared-method)
    Flow,      // execution order violated (Exit For outside loop, function without Return)
    Codegen,   // something that cannot be expressed in bytecode (too many constants or variables)
    Internal   // compiler error, not the program
};

struct Diagnostic {
    ErrorKind kind;
    int line;
    std::string message;
};

class Diagnostics {
public:
    void error(ErrorKind kind, int line, const char* format, ...);

    bool hasErrors() const { return !items.empty(); }
    size_t count() const { return items.size(); }
    const std::vector<Diagnostic>& all() const { return items; }

    void print() const;

private:
    std::vector<Diagnostic> items;
};
