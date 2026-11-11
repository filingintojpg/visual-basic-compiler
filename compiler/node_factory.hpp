#pragma once
#include <string>
#include <vector>
#include "nodes.hpp"

/* List utility */

template <class T>
std::vector<T>* list() {
    return new std::vector<T>();
}

template <class T>
std::vector<T>* list_of(T first) {
    auto* result = list<T>();
    result->push_back(first);
    return result;
}

template <class T>
std::vector<T>* list_add(std::vector<T>* items, T item) {
    items->push_back(item);
    return items;
}

/* Program and classes */

ProgramNode* create_program(std::vector<ClassNode*>* classes);
ClassNode* create_class(AccessModifier access, std::string* name, std::string* parent, std::vector<Node*>* members);

/* Class members */

struct MemberModifiers {
    AccessModifier access;
    bool isStatic;
};

MemberModifiers modifiers(AccessModifier access, bool isStatic);
FieldNode* create_field(VarKind kind, MemberModifiers mods, bool extraShared, std::vector<VariableNode*>* declarators);
MethodNode* create_function(MemberModifiers mods, std::string* name, std::vector<VariableNode*>* params, TypeNode* returnType, Block* body);
MethodNode* create_sub(MemberModifiers mods, std::string* name, std::vector<VariableNode*>* params, Block* body);

/* Variables and parameters */

VariableNode* create_variable(std::string* name, TypeNode* type, ExprNode* value);
VariableNode* create_array_variable(std::string* name, TypeNode* elementType, std::vector<ExprNode*>* dimensions, ExprNode* value);
VariableNode* create_variable_new(std::string* name, TypeNode* type, std::vector<ExprNode*>* args);
VariableNode* create_optional_parameter(std::string* name, TypeNode* type, ExprNode* defaultValue);

/* Types */

TypeNode* create_type(DataType kind);
TypeNode* create_user_type(std::string* name);
TypeNode* create_array_type(TypeNode* elementType, int rank = 1);

/* Expressions */

ExprNode* create_id(std::string* name);
ExprNode* create_id(const char* name);

ExprNode* create_int(int value);
ExprNode* create_float(float value);
ExprNode* create_string(std::string* value);
ExprNode* create_char(char value);
ExprNode* create_bool(bool value);

ExprNode* create_simple_expr(ExprType type);

ExprNode* create_binary(ExprNode* left, ExprNode* right, ExprType op);
ExprNode* create_unary(ExprNode* operand, ExprType op);

ExprNode* create_member_access(ExprNode* left, std::string* name);
ExprNode* create_call_or_index(ExprNode* callee, std::vector<ExprNode*>* args);

ExprNode* create_cast(ExprNode* operand, TypeNode* type);
ExprNode* create_if_expr(ExprNode* condition, ExprNode* thenExpr, ExprNode* elseExpr);
ExprNode* create_coalesce(ExprNode* left, ExprNode* right);

ExprNode* create_new(TypeNode* type, std::vector<ExprNode*>* args, std::vector<ExprNode*>* initializer);
ExprNode* create_collection(std::vector<ExprNode*>* elements);

/* Statements */

StmtNode* create_assign_or_call_stmt(ExprNode* expr);
StmtNode* create_call_stmt(ExprNode* expr);
StmtNode* create_assignment(ExprNode* lvalue, ExprNode* rvalue);
StmtNode* create_return(ExprNode* value);
StmtNode* create_simple_stmt(StmtType type);

StmtNode* create_if(ExprNode* condition, Block* thenBlock, std::vector<ElseifClause>* elseifs, Block* elseBlock);
std::vector<ElseifClause>* elseifs_add(std::vector<ElseifClause>* list, ExprNode* condition, Block* body);

StmtNode* create_select(ExprNode* subject, std::vector<CaseClause>* cases, Block* elseBlock);
std::vector<CaseClause>* cases_add(std::vector<CaseClause>* list, std::vector<CaseItem>* items, Block* body);

CaseItem* create_case_value(ExprNode* value);
CaseItem* create_case_range(ExprNode* from, ExprNode* to);
CaseItem* create_case_compare(ExprType op, ExprNode* value);
std::vector<CaseItem>* case_items_new(CaseItem* first);
std::vector<CaseItem>* case_items_add(std::vector<CaseItem>* list, CaseItem* item);

StmtNode* create_for(std::string* id, TypeNode* idType, ExprNode* from, ExprNode* to, ExprNode* step, Block* body);
StmtNode* create_for_each(std::string* id, TypeNode* idType, ExprNode* container, Block* body);
StmtNode* create_while(ExprNode* condition, Block* body);
StmtNode* create_do(Block* body, ExprNode* condition, bool conditionAtEnd, bool isUntil);

StmtNode* create_var_decl(VarKind kind, std::vector<VariableNode*>* declarators);
