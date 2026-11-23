#pragma once
#include <map>
#include <string>
#include <vector>
#include "compiler/nodes.hpp"
#include "compiler/semantic/types.hpp"

struct Record {
    virtual ~Record() = default;
};

struct ClassRecord;
struct MethodRecord;

struct VarRecord : Record {
    std::string name;
    Type* type = nullptr;
    bool isConst = false;
    int line = 0;
};

struct LocalVarRecord : VarRecord {
    int index = -1; // slot number in JVM-method
    bool isParam = false;
    bool isOptional = false;
    ExprNode* defaultValue = nullptr;
};

struct FieldRecord : VarRecord {
    ClassRecord* owner = nullptr;
    bool isStatic = false;
    bool isBuiltin = false; // field of a class from RTL
    AccessModifier access = AccessModifier::Private;
    VariableNode* node = nullptr;

    // type is being inferred from the initializer
    bool initializing = false;
    bool initDone = false;
};

struct MethodRecord : Record {
    std::string name;
    ClassRecord* owner = nullptr;
    Type* returnType = nullptr;
    std::vector<LocalVarRecord*> params;
    AccessModifier access = AccessModifier::Public;
    bool isStatic = false;
    bool isConstructor = false;
    bool isVariadic = false; // RTL-only: any arguments after declared parameters
    bool isSynthetic = false; // default constructor created by compiler for classes without explicit constructors
    bool isBuiltin = false;
    MethodNode* node = nullptr;

    // for constructors: which base constructor is called
    MethodRecord* baseCtor = nullptr;
    bool callsOwnCtor = false;

    int localCount = 0;
    std::vector<LocalVarRecord*> locals;

    size_t minArgs() const;
    size_t maxArgs() const { return params.size(); }

    std::string descriptor() const;
    std::string displayName() const;
};

struct ClassRecord : Record {
    std::string name;
    std::string jvmName;
    ClassNode* node = nullptr;
    Type* type = nullptr;
    ClassRecord* parent = nullptr;
    AccessModifier access = AccessModifier::Public;
    bool isBuiltin = false;

    std::map<std::string, FieldRecord*> fields;
    std::vector<FieldRecord*> fieldList;
    std::map<std::string, std::vector<MethodRecord*>> methods;
    std::vector<MethodRecord*> methodList;

    explicit ClassRecord(const std::string& name);

    void setParent(ClassRecord* newParent);

    bool isSubclassOf(const ClassRecord* other) const;
    FieldRecord* findField(const std::string& fieldName) const;
    std::vector<MethodRecord*> findMethods(const std::string& methodName) const;
    const std::vector<MethodRecord*>& constructors() const;
    MethodRecord* staticConstructor() const;
};

bool sameParams(const MethodRecord& a, const MethodRecord& b);
int accessRank(AccessModifier access);
