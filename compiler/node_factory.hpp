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

program_node* create_program(std::vector<class_node*>* classes);
class_node* create_class(access_modifier access, std::string* name, std::string* parent, std::vector<node*>* members);

/* Members */

struct member_modifiers {
    access_modifier access;
    bool isStatic;
};

member_modifiers modifiers(access_modifier access, bool isStatic);
field_node* create_field(var_kind kind, member_modifiers mods, bool extraShared, std::vector<variable_node*>* declarators);
method_node* create_function(member_modifiers mods, std::string* name, std::vector<variable_node*>* params, type_node* returnType, block* body);
method_node* create_sub(member_modifiers mods, std::string* name, std::vector<variable_node*>* params, block* body);

/* Variables and parameters */

variable_node* create_variable(std::string* name, type_node* type, expr_node* value);
variable_node* create_array_variable(std::string* name, type_node* elementType, std::vector<expr_node*>* dimensions, expr_node* value);
variable_node* create_variable_new(std::string* name, type_node* type, std::vector<expr_node*>* args);
variable_node* create_optional_parameter(std::string* name, type_node* type, expr_node* defaultValue);

/* Types */

type_node* create_type(data_type kind);
type_node* create_user_type(std::string* name);
type_node* create_array_type(type_node* elementType, int rank = 1);

/* Expressions */

expr_node* create_id(std::string* name);
expr_node* create_keyword_id(const char* text);          // Integer, String ... used as an expression

expr_node* create_int(int value);
expr_node* create_float(float value);
expr_node* create_string(std::string* value);
expr_node* create_char(char value);
expr_node* create_bool(bool value);

expr_node* create_simple_expr(expr_type type);           // Nothing, Me, MyClass, MyBase

expr_node* create_binary(expr_node* left, expr_node* right, expr_type op);
expr_node* create_unary(expr_node* operand, expr_type op);

expr_node* create_member_access(expr_node* left, std::string* name);
expr_node* create_call_or_index(expr_node* callee, std::vector<expr_node*>* args);

expr_node* create_cast(expr_node* operand, type_node* type);
expr_node* create_if_expr(expr_node* condition, expr_node* thenExpr, expr_node* elseExpr);
expr_node* create_coalesce(expr_node* left, expr_node* right);

// args / initializer may be nullptr; initializer != nullptr => hasInitializer = true.
expr_node* create_new(type_node* type, std::vector<expr_node*>* args,
                      std::vector<expr_node*>* initializer);
expr_node* create_collection(std::vector<expr_node*>* elements);

/* Statements */

// `stmt: expr`. a = b arrives as EqOp, so it becomes Assignment; everything else is a Call.
// Whether the expression is allowed as a statement is checked in semantics.
stmt_node* create_expr_stmt(expr_node* expr);
stmt_node* create_call_stmt(expr_node* expr);            // CALL expr
stmt_node* create_assignment(expr_node* lvalue, expr_node* rvalue, assignment_type type);
stmt_node* create_return(expr_node* value);              // value == nullptr for bare Return
stmt_node* create_simple_stmt(stmt_type type);           // Continue*/Exit*

// elseBlock == nullptr => no Else
stmt_node* create_if(expr_node* condition, block* thenBlock,
                     std::vector<elseif_clause>* elseifs, block* elseBlock);
std::vector<elseif_clause>* elseifs_add(std::vector<elseif_clause>* list, expr_node* condition,
                                        block* body);

// elseBlock == nullptr => no Case Else
stmt_node* create_select(expr_node* subject, std::vector<case_clause>* cases, block* elseBlock);
std::vector<case_clause>* cases_add(std::vector<case_clause>* list,
                                    std::vector<case_item>* items, block* body);

case_item* create_case_value(expr_node* value);
case_item* create_case_range(expr_node* from, expr_node* to);
case_item* create_case_compare(expr_type op, expr_node* value);
std::vector<case_item>* case_items_new(case_item* first);
std::vector<case_item>* case_items_add(std::vector<case_item>* list, case_item* item);

// idType / step may be nullptr
stmt_node* create_for(std::string* id, type_node* idType, expr_node* from, expr_node* to,
                      expr_node* step, block* body);
stmt_node* create_for_each(std::string* id, type_node* idType, expr_node* container, block* body);

stmt_node* create_while(expr_node* condition, block* body);

// condition == nullptr => infinite loop
stmt_node* create_do(block* body, expr_node* condition, bool conditionAtEnd, bool isUntil);

stmt_node* create_var_decl(var_kind kind, std::vector<variable_node*>* declarators);
