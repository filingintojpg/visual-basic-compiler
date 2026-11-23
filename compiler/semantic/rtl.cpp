#include "compiler/semantic/rtl.hpp"
#include <initializer_list>

/* ===== Вспомогательные функции для описания встроенных членов ===== */

// Добавляет в класс метод: addMethod(класс, "имя", тип результата, {типы параметров}, Shared ли)
static MethodRecord* addMethod(ClassRecord* cls, const std::string& name, Type* returnType, std::initializer_list<Type*> paramTypes, bool isStatic, bool isVariadic = false) {
    MethodRecord* m = new MethodRecord();
    m->name = name;
    m->owner = cls;
    m->returnType = returnType;
    m->isStatic = isStatic;
    m->isBuiltin = true;
    m->isVariadic = isVariadic;

    int number = 0;
    for (Type* t : paramTypes) {
        LocalVarRecord* p = new LocalVarRecord();
        p->name = "p" + std::to_string(number++);
        p->type = t;
        p->isParam = true;
        m->params.push_back(p);
    }
    cls->methods[name].push_back(m);
    cls->methodList.push_back(m);
    return m;
}

// Добавляет в класс поле только для чтения: addField(класс, "имя", тип, Shared ли)
static FieldRecord* addField(ClassRecord* cls, const std::string& name, Type* type, bool isStatic) {
    FieldRecord* f = new FieldRecord();
    f->name = name;
    f->type = type;
    f->owner = cls;
    f->isStatic = isStatic;
    f->isConst = true;       // значения встроенных полей менять нельзя
    f->isBuiltin = true;
    f->access = AccessModifier::Public;
    f->initDone = true;      // тип известен сразу, разбирать инициализатор не нужно
    cls->fields[name] = f;
    cls->fieldList.push_back(f);
    return f;
}

ClassRecord* Rtl::makeClass(const std::string& name, const std::string& jvmName, Type* type) {
    ClassRecord* cls = new ClassRecord(name);
    cls->jvmName = jvmName;
    cls->isBuiltin = true;
    if (type) cls->type = type;  // для String, Integer... "типом класса" служит сам примитивный тип
    _classes[name] = cls;
    return cls;
}

/* ===== Доступ ===== */

Rtl& Rtl::instance() {
    static Rtl rtl;
    return rtl;
}

ClassRecord* Rtl::find(const std::string& lowerName) const {
    auto it = _classes.find(lowerName);
    if (it == _classes.end() || it->second == _globals) return nullptr;
    return it->second;
}

ClassRecord* Rtl::classFor(const Type* type) const {
    switch (type->kind) {
        case TypeKind::Integer: return find("integer");
        case TypeKind::Single: return find("single");
        case TypeKind::Boolean: return find("boolean");
        case TypeKind::Char: return find("char");
        case TypeKind::String: return find("string");
        default: return nullptr;
    }
}

FieldRecord* Rtl::findGlobal(const std::string& lowerName) const {
    auto it = _globals->fields.find(lowerName);
    return it == _globals->fields.end() ? nullptr : it->second;
}

/* ===== Содержимое библиотеки ===== */

Rtl::Rtl() {
    Type* I = Types::Integer();
    Type* F = Types::Single();
    Type* B = Types::Boolean();
    Type* C = Types::Char();
    Type* S = Types::String();
    Type* V = Types::Void();

    // Console.WriteLine(...), Console.ReadLine()
    ClassRecord* console = makeClass("console", "vb/rtl/Console", nullptr);
    for (Type* t : {I, F, B, C}) {
        addMethod(console, "write", V, {t}, true);
        addMethod(console, "writeline", V, {t}, true);
    }
    addMethod(console, "write", V, {S}, true, true);      // Write("{0} {1}", a, b): после строки можно любые аргументы
    addMethod(console, "writeline", V, {S}, true, true);
    addMethod(console, "writeline", V, {}, true);
    addMethod(console, "readline", S, {}, true);

    // String: "abc".Length, "abc".ToUpper(), String.Empty
    ClassRecord* str = makeClass("string", "java/lang/String", S);
    addField(str, "length", I, false);
    addField(str, "empty", S, true);
    addMethod(str, "toupper", S, {}, false);
    addMethod(str, "tolower", S, {}, false);
    addMethod(str, "trim", S, {}, false);
    addMethod(str, "tostring", S, {}, false);
    addMethod(str, "substring", S, {I}, false);
    addMethod(str, "substring", S, {I, I}, false);
    addMethod(str, "indexof", I, {S}, false);
    addMethod(str, "contains", B, {S}, false);
    addMethod(str, "replace", S, {S, S}, false);
    addMethod(str, "isnullorempty", B, {S}, true);

    // Integer.Parse("5"), Integer.MaxValue, x.ToString()
    ClassRecord* integer = makeClass("integer", "vb/rtl/Integer", I);
    addField(integer, "maxvalue", I, true);
    addField(integer, "minvalue", I, true);
    addMethod(integer, "parse", I, {S}, true);
    addMethod(integer, "tostring", S, {}, false);

    ClassRecord* single = makeClass("single", "vb/rtl/Single", F);
    addField(single, "maxvalue", F, true);
    addField(single, "minvalue", F, true);
    addMethod(single, "parse", F, {S}, true);
    addMethod(single, "tostring", S, {}, false);

    ClassRecord* boolean = makeClass("boolean", "vb/rtl/Boolean", B);
    addField(boolean, "truestring", S, true);
    addField(boolean, "falsestring", S, true);
    addMethod(boolean, "parse", B, {S}, true);
    addMethod(boolean, "tostring", S, {}, false);

    ClassRecord* chr = makeClass("char", "vb/rtl/Char", C);
    addField(chr, "maxvalue", C, true);
    addField(chr, "minvalue", C, true);
    addMethod(chr, "isdigit", B, {C}, true);
    addMethod(chr, "isletter", B, {C}, true);
    addMethod(chr, "tostring", S, {}, false);

    _globals = makeClass("<globals>", "vb/rtl/Constants", nullptr);
    for (const char* name : {"vblf", "vbcr", "vbcrlf", "vbnewline", "vbtab", "vbback", "vbformfeed", "vbverticaltab", "vbnullchar", "vbnullstring"}) {
        addField(_globals, name, S, true);
    }
}
