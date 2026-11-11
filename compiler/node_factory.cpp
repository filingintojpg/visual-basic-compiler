#include "node_factory.hpp"
#include <algorithm>
#include <utility>

extern int yylineno;

/* Utility functions */

template <class T>
T* at_line(T* node) {
    node->line = yylineno;
    return node;
}

std::string take(std::string* string) {
    if (!string) return {};
    std::string value = std::move(*string);
    delete string;
    return value;
}

template <class T>
std::vector<T> take(std::vector<T>* value) {
    if (!value) return {};
    std::vector<T> result = std::move(*value);
    delete value;
    return result;
}

expr_node* make_expr(expr_type type) {
    return at_line(new expr_node(type));
}

stmt_node* make_stmt(stmt_type type) {
    return at_line(new stmt_node(type));
}

/* Program and classes */

program_node* create_program(std::vector<class_node*>* classes) {
    program_node* p = at_line(new program_node());
    p->classes = take(classes);
    return p;
}

class_node* create_class(access_modifier access, std::string* name, std::string* parent, std::vector<node*>* members) {
    class_node* c = at_line(new class_node());
    c->access = access;
    c->name = take(name);
    c->parent = take(parent);
    for (node* member : take(members)) {
        if (field_node* field = dynamic_cast<field_node*>(member)) {
            c->fields.push_back(field);
        } else if (method_node* method = dynamic_cast<method_node*>(member)) {
            c->methods.push_back(method);
        }
    }
    return c;
}

/* Members */

member_modifiers modifiers(access_modifier access, bool isStatic) { return {access, isStatic}; }

field_node* create_field(var_kind kind, member_modifiers mods, bool extraShared, std::vector<variable_node*>* declarators) {
    auto* f = at_line(new field_node());
    f->kind = kind;
    f->access = mods.access;
    f->isStatic = mods.isStatic || extraShared;
    f->declarators = take(declarators);
    return f;
}

method_node* create_function(member_modifiers mods, std::string* name,
                             std::vector<variable_node*>* params, type_node* returnType,
                             block* body) {
    auto* m = at_line(new method_node());
    m->name = take(name);
    m->returnType = returnType;
    m->params = take(params);
    m->body = take(body);
    m->access = mods.access;
    m->isStatic = mods.isStatic;
    return m;
}

method_node* create_sub(member_modifiers mods, std::string* name,
                        std::vector<variable_node*>* params, block* body) {
    auto* m = at_line(new method_node());
    m->name = take(name);
    m->returnType = nullptr;
    m->params = take(params);
    m->body = take(body);
    m->access = mods.access;
    m->isStatic = mods.isStatic;
    m->isConstructor = (m->name == "New");
    return m;
}

/* Variables and parameters */

variable_node* create_variable(std::string* name, type_node* type, expr_node* value) {
    auto* v = at_line(new variable_node());
    v->name = take(name);
    v->type = type;
    v->value = value;
    return v;
}

variable_node* create_array_variable(std::string* name, type_node* elementType, std::vector<expr_node*>* dimensions, expr_node* value) {
    auto* v = create_variable(name, elementType, value);
    v->dimensions = take(dimensions);
    elementType->arrayRank = std::max(1, static_cast<int>(v->dimensions.size()));
    return v;
}

variable_node* create_variable_new(std::string* name, type_node* type, std::vector<expr_node*>* args) {
    // The New expression gets its own copy of the type: the tree must not share nodes.
    expr_node* value = create_new(new type_node(*type), args, nullptr);
    return create_variable(name, type, value);
}

variable_node* create_optional_parameter(std::string* name, type_node* type,
                                         expr_node* defaultValue) {
    auto* v = create_variable(name, type, defaultValue);
    v->isOptional = true;
    return v;
}

/* Types */

type_node* create_type(data_type kind) { return at_line(new type_node(kind)); }

type_node* create_user_type(std::string* name) {
    return at_line(new type_node(data_type::UserType, take(name)));
}

type_node* create_array_type(type_node* elementType, int rank) {
    elementType->arrayRank = rank;
    return elementType;
}

/* Expressions */

expr_node* create_id(std::string* name) {
    auto* e = make_expr(expr_type::Id);
    e->text = take(name);
    return e;
}

expr_node* create_keyword_id(const char* text) {
    auto* e = make_expr(expr_type::Id);
    e->text = text;
    return e;
}

expr_node* create_int(int value) {
    auto* e = make_expr(expr_type::Int);
    e->intValue = value;
    return e;
}

expr_node* create_float(float value) {
    auto* e = make_expr(expr_type::Float);
    e->floatValue = value;
    return e;
}

expr_node* create_string(std::string* value) {
    auto* e = make_expr(expr_type::String);
    e->text = take(value);
    return e;
}

expr_node* create_char(char value) {
    auto* e = make_expr(expr_type::Char);
    e->charValue = value;
    return e;
}

expr_node* create_bool(bool value) {
    auto* e = make_expr(expr_type::Bool);
    e->boolValue = value;
    return e;
}

expr_node* create_simple_expr(expr_type type) { return make_expr(type); }

expr_node* create_binary(expr_node* left, expr_node* right, expr_type op) {
    auto* e = make_expr(op);
    e->left = left;
    e->right = right;
    return e;
}

expr_node* create_unary(expr_node* operand, expr_type op) {
    auto* e = make_expr(op);
    e->operand = operand;
    return e;
}

expr_node* create_member_access(expr_node* left, std::string* name) {
    auto* e = make_expr(expr_type::MemberAccess);
    e->left = left;
    e->text = take(name);
    return e;
}

expr_node* create_call_or_index(expr_node* callee, std::vector<expr_node*>* args) {
    auto* e = make_expr(expr_type::CallOrIndex);
    e->left = callee;
    e->args = take(args);
    return e;
}

expr_node* create_cast(expr_node* operand, type_node* type) {
    auto* e = make_expr(expr_type::Cast);
    e->operand = operand;
    e->datatype = type;
    return e;
}

expr_node* create_if_expr(expr_node* condition, expr_node* thenExpr, expr_node* elseExpr) {
    auto* e = make_expr(expr_type::If);
    e->condition = condition;
    e->then_expr = thenExpr;
    e->else_expr = elseExpr;
    return e;
}

expr_node* create_coalesce(expr_node* left, expr_node* right) {
    auto* e = make_expr(expr_type::Coalesce);
    e->left = left;
    e->right = right;
    return e;
}

expr_node* create_new(type_node* type, std::vector<expr_node*>* args,
                      std::vector<expr_node*>* initializer) {
    auto* e = make_expr(expr_type::New);
    e->datatype = type;
    e->args = take(args);
    if (initializer) {
        e->hasInitializer = true;
        e->elements = take(initializer);
    }
    return e;
}

expr_node* create_collection(std::vector<expr_node*>* elements) {
    auto* e = make_expr(expr_type::Collection);
    e->elements = take(elements);
    return e;
}

/* Statements */

stmt_node* create_expr_stmt(expr_node* expr) {
    if (expr->type == expr_type::EqOp) {
        return create_assignment(expr->left, expr->right, assignment_type::Assign);
    }
    return create_call_stmt(expr);
}

stmt_node* create_call_stmt(expr_node* expr) {
    auto* s = make_stmt(stmt_type::Call);
    s->expr = expr;
    return s;
}

stmt_node* create_assignment(expr_node* lvalue, expr_node* rvalue, assignment_type type) {
    auto* s = make_stmt(stmt_type::Assignment);
    s->lvalue = lvalue;
    s->rvalue = rvalue;
    s->assign_type = type;
    return s;
}

stmt_node* create_return(expr_node* value) {
    auto* s = make_stmt(stmt_type::Return);
    s->expr = value;
    return s;
}

stmt_node* create_simple_stmt(stmt_type type) { return make_stmt(type); }

stmt_node* create_if(expr_node* condition, block* thenBlock,
                     std::vector<elseif_clause>* elseifs, block* elseBlock) {
    auto* s = make_stmt(stmt_type::If);
    s->condition = condition;
    s->body = take(thenBlock);
    s->elseifs = take(elseifs);
    s->else_block = take(elseBlock);
    return s;
}

std::vector<elseif_clause>* elseifs_add(std::vector<elseif_clause>* list, expr_node* condition,
                                        block* body) {
    elseif_clause clause;
    clause.condition = condition;
    clause.body = take(body);
    list->push_back(std::move(clause));
    return list;
}

stmt_node* create_select(expr_node* subject, std::vector<case_clause>* cases, block* elseBlock) {
    auto* s = make_stmt(stmt_type::Select);
    s->expr = subject;
    s->cases = take(cases);
    s->else_block = take(elseBlock);
    return s;
}

std::vector<case_clause>* cases_add(std::vector<case_clause>* list,
                                    std::vector<case_item>* items, block* body) {
    case_clause clause;
    clause.items = take(items);
    clause.body = take(body);
    list->push_back(std::move(clause));
    return list;
}

case_item* create_case_value(expr_node* value) {
    auto* c = new case_item();
    c->kind = case_kind::Value;
    c->value = value;
    return c;
}

case_item* create_case_range(expr_node* from, expr_node* to) {
    auto* c = new case_item();
    c->kind = case_kind::Range;
    c->value = from;
    c->to = to;
    return c;
}

case_item* create_case_compare(expr_type op, expr_node* value) {
    auto* c = new case_item();
    c->kind = case_kind::Compare;
    c->op = op;
    c->value = value;
    return c;
}

std::vector<case_item>* case_items_new(case_item* first) {
    auto* list = new std::vector<case_item>();
    list->push_back(*first);
    delete first;
    return list;
}

std::vector<case_item>* case_items_add(std::vector<case_item>* list, case_item* item) {
    list->push_back(*item);
    delete item;
    return list;
}

stmt_node* create_for(std::string* id, type_node* idType, expr_node* from, expr_node* to,
                      expr_node* step, block* body) {
    auto* s = make_stmt(stmt_type::For);
    s->id = take(id);
    s->id_type = idType;
    s->from_expr = from;
    s->to_expr = to;
    s->step_expr = step;
    s->body = take(body);
    return s;
}

stmt_node* create_for_each(std::string* id, type_node* idType, expr_node* container,
                           block* body) {
    auto* s = make_stmt(stmt_type::ForEach);
    s->id = take(id);
    s->id_type = idType;
    s->container_expr = container;
    s->body = take(body);
    return s;
}

stmt_node* create_while(expr_node* condition, block* body) {
    auto* s = make_stmt(stmt_type::While);
    s->condition = condition;
    s->body = take(body);
    return s;
}

stmt_node* create_do(block* body, expr_node* condition, bool conditionAtEnd, bool isUntil) {
    auto* s = make_stmt(stmt_type::Do);
    s->body = take(body);
    s->condition = condition;
    s->conditionAtEnd = conditionAtEnd;
    s->isUntil = isUntil;
    return s;
}

stmt_node* create_var_decl(var_kind kind, std::vector<variable_node*>* declarators) {
    auto* s = make_stmt(stmt_type::VarDecl);
    s->var_type = kind;
    s->declarators = take(declarators);
    return s;
}
