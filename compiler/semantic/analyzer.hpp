#pragma once
#include <cstdarg>
#include <map>
#include <string>
#include <vector>
#include "compiler/nodes.hpp"
#include "compiler/semantic/diagnostics.hpp"
#include "compiler/semantic/records.hpp"
#include "compiler/semantic/rtl.hpp"

#if defined(__GNUC__)
#define PRINTF_FORMAT(format_index, args_index) __attribute__((format(printf, format_index, args_index)))
#endif

// Works in several passes
//   1. Classes: make records for all classes
//   2. Members: children, fields, method signatures, searching Main()
//   3. Method bodies: TODO
class SemanticAnalyzer {
public:
    bool analyze(ProgramNode* program);

    Diagnostics diagnostics;
    std::vector<ClassRecord*> classes;
    MethodRecord* entryPoint = nullptr;

private:
    void nameError(int line, const char* format, ...) PRINTF_FORMAT(3, 4);
    void typeError(int line, const char* format, ...) PRINTF_FORMAT(3, 4);
    void valueError(int line, const char* format, ...) PRINTF_FORMAT(3, 4);
    void flowError(int line, const char* format, ...) PRINTF_FORMAT(3, 4);
    void report(ErrorKind kind, int line, const char* format, va_list args);

    /* First pass */
    ClassRecord* findClass(const std::string& name) const;
    void declareClasses(ProgramNode* program);

    /* Second pass */
    void resolveParents();
    Type* resolveType(TypeNode* node);
    void declareMembers(ClassRecord* cls);
    void declareField(ClassRecord* cls, FieldNode* decl, VariableNode* node);
    void declareMethod(ClassRecord* cls, MethodNode* node);
    void checkOverrides(ClassRecord* cls);
    void findEntryPoint();

    std::map<std::string, ClassRecord*> _classMap;
};
