#include "compiler/semantic/analyzer.hpp"
#include <cstdio>
#include <set>

/* ===== Точка входа ===== */

bool SemanticAnalyzer::analyze(ProgramNode* program) {
    declareClasses(program);                            // проход 1
    resolveParents();                                   // проход 2
    for (ClassRecord* cls : classes) declareMembers(cls);
    for (ClassRecord* cls : classes) checkOverrides(cls);
    findEntryPoint();
    return !diagnostics.hasErrors();
}

/* ===== Проход 1: классы ===== */

ClassRecord* SemanticAnalyzer::findClass(const std::string& name) const {
    auto it = _classMap.find(name);
    return it == _classMap.end() ? nullptr : it->second;
}

void SemanticAnalyzer::declareClasses(ProgramNode* program) {
    for (ClassNode* node : program->classes) {
        if (findClass(node->name)) {
            nameError(node->line, "Class '%s' is already declared", node->name.c_str());
            continue;
        }
        ClassRecord* cls = new ClassRecord(node->name);
        cls->node = node;
        cls->access = node->access;
        node->ref = cls;                 // связываем AST с записью
        _classMap[cls->name] = cls;
        classes.push_back(cls);
    }
}

/* ===== Проход 2: предки, поля, сигнатуры ===== */

void SemanticAnalyzer::resolveParents() {
    for (ClassRecord* cls : classes) {
        const std::string& parentName = cls->node->parent;
        if (parentName.empty()) continue;

        ClassRecord* parent = findClass(parentName);
        if (!parent) {
            nameError(cls->node->line, "Class '%s' inherits from undefined class '%s'", cls->name.c_str(), parentName.c_str());
        } else if (parent == cls) {
            typeError(cls->node->line, "Class '%s' cannot inherit from itself", cls->name.c_str());
        } else {
            cls->setParent(parent);
        }
    }

    // Цикл наследования (A от B, B от A) приведёт к бесконечному обходу предков: ловим и разрываем
    for (ClassRecord* cls : classes) {
        std::set<ClassRecord*> seen{cls};
        for (ClassRecord* p = cls->parent; p; p = p->parent) {
            if (!seen.insert(p).second) {
                typeError(cls->node->line, "Cyclic inheritance involving class '%s'", cls->name.c_str());
                cls->setParent(nullptr);
                break;
            }
        }
    }
}

// TypeNode ("то, что написано") -> Type ("то, с чем работаем")
Type* SemanticAnalyzer::resolveType(TypeNode* node) {
    if (!node) return nullptr;
    if (node->resolved) return node->resolved;

    Type* base = nullptr;
    switch (node->kind) {
        case DataType::Integer: base = Types::Integer(); break;
        case DataType::Boolean: base = Types::Boolean(); break;
        case DataType::Char: base = Types::Char(); break;
        case DataType::String: base = Types::String(); break;
        case DataType::Single: base = Types::Single(); break;
        case DataType::UserType: {
            ClassRecord* cls = findClass(node->name);
            if (!cls) {
                nameError(node->line, "Type '%s' is not declared", node->name.c_str());
                base = Types::Error();
            } else {
                base = cls->type;
            }
            break;
        }
    }
    // Dim a() As Integer: TypeNode хранит число измерений в arrayRank
    if (node->arrayRank > 0 && !base->isError()) base = Types::arrayOf(base, node->arrayRank);

    node->resolved = base;
    return base;
}

void SemanticAnalyzer::declareMembers(ClassRecord* cls) {
    for (FieldNode* field : cls->node->fields) {
        for (VariableNode* v : field->declarators) declareField(cls, field, v);
    }
    for (MethodNode* method : cls->node->methods) declareMethod(cls, method);

    // Если конструкторов нет, компилятор создаёт пустой конструктор по умолчанию (как и в VB)
    if (cls->constructors().empty()) {
        MethodRecord* ctor = new MethodRecord();
        ctor->name = "<init>";
        ctor->owner = cls;
        ctor->returnType = Types::Void();
        ctor->access = AccessModifier::Public;
        ctor->isConstructor = true;
        ctor->isSynthetic = true;
        ctor->localCount = 1;            // ячейка 0 занята под this
        cls->methods["<init>"].push_back(ctor);
        cls->methodList.push_back(ctor);
    }
}

void SemanticAnalyzer::declareField(ClassRecord* cls, FieldNode* decl, VariableNode* node) {
    if (cls->fields.count(node->name)) {
        nameError(node->line, "Field '%s' is already declared in class '%s'", node->name.c_str(), cls->name.c_str());
        return;
    }
    FieldRecord* field = new FieldRecord();
    field->name = node->name;
    field->owner = cls;
    field->node = node;
    field->line = node->line;
    field->access = decl->access;
    field->isConst = decl->kind == VarKind::Const;
    field->isStatic = decl->isStatic || field->isConst;   // Const в VB неявно Shared
    // Тип может быть не указан (Private x = 5): тогда он выводится из значения, это сделаем на шаге про выражения
    field->type = node->type ? resolveType(node->type) : nullptr;

    node->ref = field;
    cls->fields[field->name] = field;
    cls->fieldList.push_back(field);
}

void SemanticAnalyzer::declareMethod(ClassRecord* cls, MethodNode* node) {
    MethodRecord* method = new MethodRecord();
    method->owner = cls;
    method->node = node;
    method->access = node->access;
    method->isStatic = node->isStatic;
    method->isConstructor = node->isConstructor && !node->isStatic;
    if (node->isConstructor) {
        method->name = node->isStatic ? "<clinit>" : "<init>";   // так конструкторы называются в JVM
    } else {
        method->name = node->name;
    }
    method->returnType = node->returnType ? resolveType(node->returnType) : Types::Void();
    node->ref = method;

    // Параметры
    bool seenOptional = false;
    std::set<std::string> names;
    for (VariableNode* p : node->params) {
        LocalVarRecord* param = new LocalVarRecord();
        param->name = p->name;
        param->type = resolveType(p->type);
        param->line = p->line;
        param->isParam = true;
        param->isOptional = p->isOptional;
        param->defaultValue = p->isOptional ? p->value : nullptr;
        p->ref = param;

        if (!names.insert(p->name).second) {
            nameError(p->line, "Parameter '%s' is declared twice in '%s'", p->name.c_str(), node->name.c_str());
        }
        if (p->isOptional) {
            seenOptional = true;
        } else if (seenOptional) {
            typeError(p->line, "Parameter '%s': required parameters cannot follow optional ones", p->name.c_str());
        }
        method->params.push_back(param);
    }
    if (method->name == "<clinit>" && !method->params.empty()) {
        typeError(node->line, "Shared constructor cannot have parameters");
    }

    // Конфликты имён
    if (cls->fields.count(method->name)) {
        nameError(node->line, "'%s' is already declared as a field in class '%s'", method->name.c_str(), cls->name.c_str());
        return;
    }
    for (const MethodRecord* other : cls->methods[method->name]) {
        if (sameSignature(*other, *method)) {
            nameError(node->line, "Method '%s' is already declared in class '%s' with the same signature",
                      method->displayName().c_str(), cls->name.c_str());
            return;
        }
    }
    cls->methods[method->name].push_back(method);
    cls->methodList.push_back(method);
}

// Метод потомка с той же сигнатурой, что у метода предка, "переопределяет" его (в JVM все методы виртуальные).
// Это допустимо, только если результат тот же, Shared совпадает и доступ не сужен.
void SemanticAnalyzer::checkOverrides(ClassRecord* cls) {
    if (!cls->parent) return;
    for (MethodRecord* m : cls->methodList) {
        if (m->name == "<init>" || m->name == "<clinit>") continue;
        for (MethodRecord* base : cls->parent->findMethods(m->name)) {
            if (!sameSignature(*base, *m)) continue;

            int line = m->node ? m->node->line : 0;
            if (base->isStatic != m->isStatic) {
                typeError(line, "Method '%s' cannot differ from the base method in being Shared", m->displayName().c_str());
            } else if (!Types::same(base->returnType, m->returnType)) {
                typeError(line, "Method '%s' overrides a base method with a different return type", m->displayName().c_str());
            } else if (base->access != AccessModifier::Private && accessRank(m->access) < accessRank(base->access)) {
                typeError(line, "Method '%s' cannot reduce the access of the base method", m->displayName().c_str());
            }
        }
    }
}

// Ищем точку входа: Shared Sub Main() или Shared Sub Main(args() As String). Она должна быть ровно одна.
void SemanticAnalyzer::findEntryPoint() {
    std::vector<MethodRecord*> found;
    bool misdeclared = false;   // метод с именем Main есть, но объявлен неправильно

    for (ClassRecord* cls : classes) {
        auto it = cls->methods.find("main");     // лексер приводит имена к нижнему регистру
        if (it == cls->methods.end()) continue;

        for (MethodRecord* m : it->second) {
            bool isSub = m->returnType->kind == TypeKind::Void;
            bool paramsOk = m->params.empty() ||
                            (m->params.size() == 1 && m->params[0]->type->kind == TypeKind::Array &&
                             m->params[0]->type->rank == 1 && m->params[0]->type->elem->kind == TypeKind::String);
            if (m->isStatic && isSub && paramsOk) {
                found.push_back(m);
            } else {
                misdeclared = true;
            }
        }
    }

    if (found.empty()) {
        nameError(0, misdeclared
            ? "Entry point is missing: 'Main' must be a Shared Sub with no parameters or one String() parameter"
            : "Entry point is missing: a Shared Sub Main is required");
    } else if (found.size() > 1) {
        nameError(found[1]->node ? found[1]->node->line : 0, "Too many entry points: the program must have one Shared Sub Main");
    } else {
        entryPoint = found[0];
    }
}

/* ===== Сообщения об ошибках ===== */

void SemanticAnalyzer::report(ErrorKind kind, int line, const char* format, va_list args) {
    char buffer[1024];
    vsnprintf(buffer, sizeof(buffer), format, args);   // подставляем %s и т.п. в текст
    diagnostics.error(kind, line, "%s", buffer);
}

void SemanticAnalyzer::nameError(int line, const char* format, ...) {
    va_list args;
    va_start(args, format);
    report(ErrorKind::Name, line, format, args);
    va_end(args);
}

void SemanticAnalyzer::typeError(int line, const char* format, ...) {
    va_list args;
    va_start(args, format);
    report(ErrorKind::Type, line, format, args);
    va_end(args);
}

void SemanticAnalyzer::valueError(int line, const char* format, ...) {
    va_list args;
    va_start(args, format);
    report(ErrorKind::Value, line, format, args);
    va_end(args);
}

void SemanticAnalyzer::flowError(int line, const char* format, ...) {
    va_list args;
    va_start(args, format);
    report(ErrorKind::Flow, line, format, args);
    va_end(args);
}
