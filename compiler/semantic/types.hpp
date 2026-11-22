#pragma once
#include <string>

struct ClassRecord;

enum class TypeKind { Void, Integer, Boolean, Char, String, Single, Null, Class, Array, Error };

struct Type {
    TypeKind kind;

    std::string className;
    Type* parent = nullptr;
    ClassRecord* cls = nullptr;

    Type* elem = nullptr;
    int rank = 0;

    explicit Type(TypeKind kind) : kind(kind) {}
    explicit Type(TypeKind kind, const std::string& className) : kind(kind), className(className) {}
    explicit Type(TypeKind kind, Type* elem, int rank) : kind(kind), elem(elem), rank(rank) {}

    bool isError() const { return kind == TypeKind::Error; }
    bool isNumeric() const { return kind == TypeKind::Integer || kind == TypeKind::Single; }
    bool isPrimitive() const { return kind == TypeKind::Integer || kind == TypeKind::Boolean || kind == TypeKind::Char || kind == TypeKind::Single; }
    bool isReference() const { return kind == TypeKind::String || kind == TypeKind::Class || kind == TypeKind::Array || kind == TypeKind::Null; }
    bool isConstType() const { return isPrimitive() || kind == TypeKind::String; }
    bool isArray() const { return kind == TypeKind::Array; }

    std::string name() const;
    std::string descriptor() const;

    // Этот класс является потомком other (или им самим)? Только для Class.
    bool isSubclassOf(const Type* other) const;

    // Можно ли без преобразования положить значение типа `from` в переменную этого типа
    // (тот же тип, Integer -> Single, Char -> String, потомок -> предок, Nothing -> ссылка)
    bool isAssignableFrom(const Type* from) const;
};

// Фабрика типов: простые типы создаются один раз и дальше используются по указателю,
// поэтому их можно сравнивать через ==.
struct Types {
    static Type* Void();
    static Type* Integer();
    static Type* Boolean();
    static Type* Char();
    static Type* String();
    static Type* Single();
    static Type* Null();
    static Type* Error();

    static Type* classType(const std::string& name);
    static Type* arrayOf(Type* elem, int rank);

    static bool same(const Type* a, const Type* b);

    // Общий тип двух выражений (для If(cond, a, b) и литералов массивов); nullptr, если его нет
    static Type* common(Type* a, Type* b);

    // Насколько значение типа `from` подходит приёмнику `to` при неявном приведении (как в VB без Option Strict):
    //   3 - тот же тип
    //   2 - расширение или подтип (Integer -> Single, Char -> String, Dog -> Animal, Nothing -> ссылка)
    //   1 - преобразование с возможной потерей или проверкой (Single -> Integer, String <-> числа,
    //       Integer <-> Boolean, числа -> String, String -> Char, Animal -> Dog)
    //   0 - неявное приведение невозможно
    static int conversionRank(const Type* from, const Type* to);
};
