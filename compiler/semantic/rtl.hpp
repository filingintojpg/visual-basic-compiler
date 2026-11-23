#pragma once
#include <map>
#include <string>
#include "compiler/semantic/records.hpp"

class Rtl {
public:
    static Rtl& instance();

    ClassRecord* find(const std::string& lowerName) const;
    ClassRecord* classFor(const Type* type) const;
    FieldRecord* findGlobal(const std::string& lowerName) const;

private:
    Rtl();
    ClassRecord* makeClass(const std::string& name, const std::string& jvmName, Type* type);

    std::map<std::string, ClassRecord*> _classes;
    ClassRecord* _globals = nullptr;
};
