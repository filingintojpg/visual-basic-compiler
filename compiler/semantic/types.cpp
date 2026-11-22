#include "compiler/semantic/types.hpp"
#include <map>
#include <utility>

Type* Types::Void()    { static Type* t = new Type(TypeKind::Void);    return t; }
Type* Types::Integer() { static Type* t = new Type(TypeKind::Integer); return t; }
Type* Types::Boolean() { static Type* t = new Type(TypeKind::Boolean); return t; }
Type* Types::Char()    { static Type* t = new Type(TypeKind::Char);    return t; }
Type* Types::String()  { static Type* t = new Type(TypeKind::String);  return t; }
Type* Types::Single()  { static Type* t = new Type(TypeKind::Single);  return t; }
Type* Types::Null()    { static Type* t = new Type(TypeKind::Null);    return t; }
Type* Types::Error()   { static Type* t = new Type(TypeKind::Error);   return t; }

Type* Types::classType(const std::string& name) { return new Type(TypeKind::Class, name); }

Type* Types::arrayOf(Type* elem, int rank) {
    static std::map<std::pair<Type*, int>, Type*> cachedArrayTypes;
    auto key = std::make_pair(elem, rank);
    auto it = cachedArrayTypes.find(key);
    if (it != cachedArrayTypes.end()) return it->second;

    Type* t = new Type(TypeKind::Array, elem, rank);
    cachedArrayTypes[key] = t;
    return t;
}

bool Types::same(const Type* a, const Type* b) {
    if (a == b) return true;
    if (!a || !b || a->kind != b->kind) return false;
    switch (a->kind) {
        case TypeKind::Class: return a->className == b->className;
        case TypeKind::Array: return a->rank == b->rank && same(a->elem, b->elem);
        default:              return true;
    }
}

bool Type::isSubclassOf(const Type* other) const {
    for (const Type* t = this; t; t = t->parent) {
        if (Types::same(t, other)) return true;
    }
    return false;
}

bool Type::isAssignableFrom(const Type* from) const {
    if (isError() || !from || from->isError()) return true;
    if (Types::same(this, from)) return true;

    switch (kind) {
        case TypeKind::Single:
            return from->kind == TypeKind::Integer;                          // Integer -> Single
        case TypeKind::String:
            return from->kind == TypeKind::Char || from->kind == TypeKind::Null;  // Char -> String, Nothing -> String
        case TypeKind::Class:
            if (from->kind == TypeKind::Null) return true;
            return from->kind == TypeKind::Class && from->isSubclassOf(this);     // Dog -> Animal
        case TypeKind::Array:
            if (from->kind == TypeKind::Null) return true;
            if (from->kind != TypeKind::Array || from->rank != rank) return false;
            if (elem->kind == TypeKind::Class && from->elem->kind == TypeKind::Class) {
                return elem->isAssignableFrom(from->elem);                       // Dog() -> Animal()
            }
            return Types::same(elem, from->elem);
        default:
            return false;
    }
}

Type* Types::common(Type* a, Type* b) {
    if (a->isError() || b->isError()) return Error();
    if (a->isAssignableFrom(b)) return a;
    if (b->isAssignableFrom(a)) return b;

    // Два разных класса с общим предком: берём ближайшего общего предка
    if (a->kind == TypeKind::Class && b->kind == TypeKind::Class) {
        for (Type* p = a->parent; p; p = p->parent) {
            if (b->isSubclassOf(p)) return p;
        }
    }
    return nullptr;
}

int Types::conversionRank(const Type* from, const Type* to) {
    if (!from || !to || from->isError() || to->isError()) return 3;
    if (same(from, to)) return 3;
    if (to->isAssignableFrom(from)) return 2;

    switch (to->kind) {
        case TypeKind::Integer:
        case TypeKind::Single:
        case TypeKind::Boolean:
            return (from->isNumeric() || from->kind == TypeKind::Boolean || from->kind == TypeKind::String) ? 1 : 0;
        case TypeKind::String:
            return from->isPrimitive() ? 1 : 0;
        case TypeKind::Char:
            return from->kind == TypeKind::String ? 1 : 0;
        case TypeKind::Class:  // Animal -> Dog: проверяется во время выполнения
            return from->kind == TypeKind::Class && to->isSubclassOf(from) ? 1 : 0;
        default:
            return 0;
    }
}

/* ===== Текстовые представления ===== */

std::string Type::name() const {
    switch (kind) {
        case TypeKind::Void: return "Void";
        case TypeKind::Integer: return "Integer";
        case TypeKind::Boolean: return "Boolean";
        case TypeKind::Char: return "Char";
        case TypeKind::String: return "String";
        case TypeKind::Single: return "Single";
        case TypeKind::Null: return "Nothing";
        case TypeKind::Error: return "<error>";
        case TypeKind::Class: return className;
        case TypeKind::Array: return elem->name() + "(" + std::string(rank > 1 ? rank - 1 : 0, ',') + ")";
    }
    return "?";
}

std::string Type::descriptor() const {
    switch (kind) {
        case TypeKind::Void: return "V";
        case TypeKind::Integer: return "I";
        case TypeKind::Boolean: return "Z";
        case TypeKind::Char: return "C";
        case TypeKind::Single: return "F";
        case TypeKind::String: return "Ljava/lang/String;";
        case TypeKind::Class: return "L" + className + ";";
        case TypeKind::Array: return std::string(rank, '[') + elem->descriptor();
        case TypeKind::Null:
        case TypeKind::Error: return "Ljava/lang/Object;";
    }
    return "?";
}
