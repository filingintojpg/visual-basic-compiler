#include "compiler/semantic/records.hpp"

/* MethodRecord */

size_t MethodRecord::minArgs() const {
    size_t count = 0;
    for (const LocalVarRecord* p : params) {
        if (!p->isOptional) {
            count++;
        }
    }
    return count;
}

std::string MethodRecord::descriptor() const {
    std::string result = "(";
    for (const LocalVarRecord* p : params) {
        result += p->type->descriptor();
    }
    result += ")";

    result += (isConstructor || name == "<clinit>") 
        ? "V" 
        : returnType->descriptor();

    return result;
}

std::string MethodRecord::displayName() const {
    std::string result = isConstructor ? "New" : name;
    result += "(";

    for (size_t i = 0; i < params.size(); i++) {
        if (i > 0) {   
            result += ", ";
        }
        result += params[i]->type->name();
    }
    return result + ")";
}

/* ClassRecord */

ClassRecord::ClassRecord(const std::string& name) : name(name), jvmName(name) {
    type = Types::classType(name);
    type->cls = this;
}

void ClassRecord::setParent(ClassRecord* newParent) {
    parent = newParent;
    type->parent = newParent ? newParent->type : nullptr;
}

bool ClassRecord::isSubclassOf(const ClassRecord* other) const {
    for (const ClassRecord* c = this; c; c = c->parent) {
        if (c == other) {
            return true;
        }
    }
    return false;
}

FieldRecord* ClassRecord::findField(const std::string& fieldName) const {
    for (const ClassRecord* c = this; c; c = c->parent) {
        auto it = c->fields.find(fieldName);
        if (it != c->fields.end()) {
            return it->second;
        }
    }
    return nullptr;
}

std::vector<MethodRecord*> ClassRecord::findMethods(const std::string& methodName) const {
    for (const ClassRecord* c = this; c; c = c->parent) {
        auto it = c->methods.find(methodName);
        if (it == c->methods.end()) {
            continue;
        }
        return it->second;
    }
    return {};
}

const std::vector<MethodRecord*>& ClassRecord::constructors() const {
    static const std::vector<MethodRecord*> none;
    auto it = methods.find("<init>");
    return it == methods.end() 
            ? none 
            : it->second;
}

MethodRecord* ClassRecord::staticConstructor() const {
    auto it = methods.find("<clinit>");
    return (it == methods.end() || it->second.empty()) 
            ? nullptr 
            : it->second.front();
}

/* Utility functions */

int accessRank(AccessModifier access) {
    switch (access) {
        case AccessModifier::Private:   return 0;
        case AccessModifier::Protected: return 1;
        case AccessModifier::Public:    return 2;
    }
    return 2;
}
