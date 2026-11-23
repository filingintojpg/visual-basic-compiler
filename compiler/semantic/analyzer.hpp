#pragma once
#include <cstdarg>
#include <map>
#include <string>
#include <vector>
#include "compiler/nodes.hpp"
#include "compiler/semantic/diagnostics.hpp"
#include "compiler/semantic/records.hpp"
#include "compiler/semantic/rtl.hpp"

// Помогает компилятору проверять, что в сообщениях об ошибках %s и аргументы совпадают
#if defined(__GNUC__)
#define PRINTF_FORMAT(format_index, args_index) __attribute__((format(printf, format_index, args_index)))
#else
#define PRINTF_FORMAT(format_index, args_index)
#endif

// Семантический анализатор: проверяет смысл программы и собирает таблицы символов.
//
// Работает в несколько проходов (на этом шаге готовы первые два):
//   1. Классы:   заводим запись для каждого класса (чтобы можно было ссылаться на классы, объявленные ниже).
//   2. Члены:    предки, поля, сигнатуры методов, поиск Main.
//   3. Тела:     проверка кода внутри методов (будет на следующих шагах).
//
// Использование:
//   SemanticAnalyzer analyzer;
//   if (!analyzer.analyze(program_root)) { analyzer.diagnostics.print(std::cerr); return 1; }
class SemanticAnalyzer {
public:
    bool analyze(ProgramNode* program);   // true - ошибок нет

    Diagnostics diagnostics;              // найденные ошибки
    std::vector<ClassRecord*> classes;    // пользовательские классы в порядке объявления
    MethodRecord* entryPoint = nullptr;   // Shared Sub Main

private:
    // Короткие обёртки: добавить ошибку нужного вида. Формат как у printf: nameError(line, "Name '%s' ...", name.c_str())
    void nameError(int line, const char* format, ...) PRINTF_FORMAT(3, 4);    // имя не найдено / объявлено дважды
    void typeError(int line, const char* format, ...) PRINTF_FORMAT(3, 4);    // типы не подходят
    void valueError(int line, const char* format, ...) PRINTF_FORMAT(3, 4);   // недопустимое использование
    void flowError(int line, const char* format, ...) PRINTF_FORMAT(3, 4);    // нарушен порядок выполнения
    void report(ErrorKind kind, int line, const char* format, va_list args);

    /* Проход 1 */
    ClassRecord* findClass(const std::string& name) const;
    void declareClasses(ProgramNode* program);

    /* Проход 2 */
    void resolveParents();
    Type* resolveType(TypeNode* node);                 // TypeNode из AST -> настоящий Type
    void declareMembers(ClassRecord* cls);
    void declareField(ClassRecord* cls, FieldNode* decl, VariableNode* node);
    void declareMethod(ClassRecord* cls, MethodNode* node);
    void checkOverrides(ClassRecord* cls);
    void findEntryPoint();

    std::map<std::string, ClassRecord*> classMap_;     // пользовательские классы по имени
};
