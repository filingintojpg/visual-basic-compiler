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

ExprNode* make_expr(ExprType type) {
    return at_line(new ExprNode(type));
}

StmtNode* make_stmt(StmtType type) {
    return at_line(new StmtNode(type));
}

bool is_binary(const ExprNode* expr) {
    return expr->type >= ExprType::AddOp &&
           expr->type <= ExprType::IsNotOp;
}

bool is_lvalue(const ExprNode* expr) {
    return !expr->parenthesized && (
        expr->type == ExprType::Id ||
        expr->type == ExprType::MemberAccess ||
        expr->type == ExprType::CallOrIndex
    );
}

ExprNode* extract_assignment(ExprNode*& root) {
    if (!is_binary(root) || root->parenthesized) return nullptr;

    if (root->type == ExprType::EqOp && is_lvalue(root->left)) {
        ExprNode* lvalue = root->left;
        root = root->right;
        return lvalue;
    }
    return extract_assignment(root->left);
}

/* Program and classes */

ProgramNode* create_program(std::vector<ClassNode*>* classes) {
    ProgramNode* p = at_line(new ProgramNode());
    p->classes = take(classes);
    return p;
}

ClassNode* create_class(AccessModifier access, std::string* name, std::string* parent, std::vector<Node*>* members) {
    ClassNode* c = at_line(new ClassNode());
    c->access = access;
    c->name = take(name);
    c->parent = take(parent);
    for (Node* member : take(members)) {
        if (FieldNode* field = dynamic_cast<FieldNode*>(member)) {
            c->fields.push_back(field);
        } else if (MethodNode* method = dynamic_cast<MethodNode*>(member)) {
            c->methods.push_back(method);
        }
    }
    return c;
}

/* Class members */

MemberModifiers modifiers(AccessModifier access, bool isStatic) {
    return {access, isStatic};
}

FieldNode* create_field(VarKind kind, MemberModifiers mods, bool extraShared, std::vector<VariableNode*>* declarators) {
    FieldNode* f = at_line(new FieldNode());
    f->kind = kind;
    f->access = mods.access;
    f->isStatic = mods.isStatic || extraShared;
    f->declarators = take(declarators);
    return f;
}

MethodNode* create_function(MemberModifiers mods, std::string* name, std::vector<VariableNode*>* params, TypeNode* returnType, Block* body) {
    MethodNode* m = at_line(new MethodNode());
    m->name = take(name);
    m->returnType = returnType;
    m->params = take(params);
    m->body = take(body);
    m->access = mods.access;
    m->isStatic = mods.isStatic;
    return m;
}

MethodNode* create_sub(MemberModifiers mods, std::string* name, std::vector<VariableNode*>* params, Block* body) {
    MethodNode* m = at_line(new MethodNode());
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

VariableNode* create_variable(std::string* name, TypeNode* type, ExprNode* value) {
    VariableNode* v = at_line(new VariableNode());
    v->name = take(name);
    v->type = type;
    v->value = value;
    return v;
}

VariableNode* create_array_variable(std::string* name, TypeNode* elementType, std::vector<ExprNode*>* dimensions, ExprNode* value) {
    VariableNode* v = create_variable(name, elementType, value);
    v->dimensions = take(dimensions);
    elementType->arrayRank = std::max(1, static_cast<int>(v->dimensions.size()));
    return v;
}

VariableNode* create_variable_new(std::string* name, TypeNode* type, std::vector<ExprNode*>* args) {
    ExprNode* value = create_new(new TypeNode(*type), args, nullptr);
    return create_variable(name, type, value);
}

VariableNode* create_optional_parameter(std::string* name, TypeNode* type, ExprNode* defaultValue) {
    VariableNode* v = create_variable(name, type, defaultValue);
    v->isOptional = true;
    return v;
}

/* Types */

TypeNode* create_type(DataType kind) {
    return at_line(new TypeNode(kind));
}

TypeNode* create_user_type(std::string* name) {
    return at_line(new TypeNode(DataType::UserType, take(name)));
}

TypeNode* create_array_type(TypeNode* elementType, int rank) {
    elementType->arrayRank = rank;
    return elementType;
}

/* Expressions */

ExprNode* create_id(std::string* name) {
    ExprNode* e = make_expr(ExprType::Id);
    e->text = take(name);
    return e;
}

ExprNode* create_id(const char* name) {
    ExprNode* e = make_expr(ExprType::Id);
    e->text = name;
    return e;
}

ExprNode* create_int(int value) {
    ExprNode* e = make_expr(ExprType::Int);
    e->intValue = value;
    return e;
}

ExprNode* create_float(float value) {
    ExprNode* e = make_expr(ExprType::Float);
    e->floatValue = value;
    return e;
}

ExprNode* create_string(std::string* value) {
    ExprNode* e = make_expr(ExprType::String);
    e->text = take(value);
    return e;
}

ExprNode* create_char(char value) {
    ExprNode* e = make_expr(ExprType::Char);
    e->charValue = value;
    return e;
}

ExprNode* create_bool(bool value) {
    ExprNode* e = make_expr(ExprType::Bool);
    e->boolValue = value;
    return e;
}

ExprNode* create_simple_expr(ExprType type) {
    return make_expr(type);
}

ExprNode* create_binary(ExprNode* left, ExprNode* right, ExprType op) {
    ExprNode* e = make_expr(op);
    e->left = left;
    e->right = right;
    return e;
}

ExprNode* create_unary(ExprNode* operand, ExprType op) {
    ExprNode* e = make_expr(op);
    e->operand = operand;
    return e;
}

ExprNode* create_member_access(ExprNode* left, std::string* name) {
    ExprNode* e = make_expr(ExprType::MemberAccess);
    e->left = left;
    e->text = take(name);
    return e;
}

ExprNode* create_call_or_index(ExprNode* callee, std::vector<ExprNode*>* args) {
    ExprNode* e = make_expr(ExprType::CallOrIndex);
    e->left = callee;
    e->args = take(args);
    return e;
}

ExprNode* create_cast(ExprNode* operand, TypeNode* type) {
    ExprNode* e = make_expr(ExprType::Cast);
    e->operand = operand;
    e->datatype = type;
    return e;
}

ExprNode* create_if_expr(ExprNode* condition, ExprNode* thenExpr, ExprNode* elseExpr) {
    ExprNode* e = make_expr(ExprType::If);
    e->condition = condition;
    e->then_expr = thenExpr;
    e->else_expr = elseExpr;
    return e;
}

ExprNode* create_coalesce(ExprNode* left, ExprNode* right) {
    ExprNode* e = make_expr(ExprType::Coalesce);
    e->left = left;
    e->right = right;
    return e;
}

ExprNode* create_new(TypeNode* type, std::vector<ExprNode*>* args, std::vector<ExprNode*>* initializer) {
    ExprNode* e = make_expr(ExprType::New);
    e->datatype = type;
    e->args = take(args);
    if (initializer) {
        e->hasInitializer = true;
        e->elements = take(initializer);
    }
    return e;
}

ExprNode* create_collection(std::vector<ExprNode*>* elements) {
    ExprNode* e = make_expr(ExprType::Collection);
    e->elements = take(elements);
    return e;
}

/* Statements */

StmtNode* create_assign_or_call_stmt(ExprNode* expr) {
    if (ExprNode* lvalue = extract_assignment(expr)) {
        return create_assignment(lvalue, expr);
    }
    return create_call_stmt(expr);
}

StmtNode* create_call_stmt(ExprNode* expr) {
    StmtNode* s = make_stmt(StmtType::Call);
    s->expr = expr;
    return s;
}

StmtNode* create_assignment(ExprNode* lvalue, ExprNode* rvalue) {
    StmtNode* s = make_stmt(StmtType::Assignment);
    s->lvalue = lvalue;
    s->rvalue = rvalue;
    return s;
}

StmtNode* create_return(ExprNode* value) {
    StmtNode* s = make_stmt(StmtType::Return);
    s->expr = value;
    return s;
}

StmtNode* create_simple_stmt(StmtType type) {
    return make_stmt(type);
}

StmtNode* create_if(ExprNode* condition, Block* thenBlock, std::vector<ElseifClause>* elseifs, Block* elseBlock) {
    StmtNode* s = make_stmt(StmtType::If);
    s->condition = condition;
    s->body = take(thenBlock);
    s->elseifs = take(elseifs);
    s->else_block = take(elseBlock);
    return s;
}

std::vector<ElseifClause>* elseifs_add(std::vector<ElseifClause>* list, ExprNode* condition, Block* body) {
    ElseifClause clause;
    clause.condition = condition;
    clause.body = take(body);
    list->push_back(std::move(clause));
    return list;
}

StmtNode* create_select(ExprNode* subject, std::vector<CaseClause>* cases, Block* elseBlock) {
    StmtNode* s = make_stmt(StmtType::Select);
    s->expr = subject;
    s->cases = take(cases);
    s->else_block = take(elseBlock);
    return s;
}

std::vector<CaseClause>* cases_add(std::vector<CaseClause>* list, std::vector<CaseItem>* items, Block* body) {
    CaseClause clause;
    clause.items = take(items);
    clause.body = take(body);
    list->push_back(std::move(clause));
    return list;
}

CaseItem* create_case_value(ExprNode* value) {
    CaseItem* c = new CaseItem();
    c->kind = CaseKind::Value;
    c->value = value;
    return c;
}

CaseItem* create_case_range(ExprNode* from, ExprNode* to) {
    CaseItem* c = new CaseItem();
    c->kind = CaseKind::Range;
    c->value = from;
    c->to = to;
    return c;
}

CaseItem* create_case_compare(ExprType op, ExprNode* value) {
    CaseItem* c = new CaseItem();
    c->kind = CaseKind::Compare;
    c->op = op;
    c->value = value;
    return c;
}

std::vector<CaseItem>* case_items_new(CaseItem* first) {
    std::vector<CaseItem>* list = new std::vector<CaseItem>();
    list->push_back(*first);
    delete first;
    return list;
}

std::vector<CaseItem>* case_items_add(std::vector<CaseItem>* list, CaseItem* item) {
    list->push_back(*item);
    delete item;
    return list;
}

StmtNode* create_for(std::string* id, TypeNode* idType, ExprNode* from, ExprNode* to, ExprNode* step, Block* body) {
    StmtNode* s = make_stmt(StmtType::For);
    s->id = take(id);
    s->id_type = idType;
    s->from_expr = from;
    s->to_expr = to;
    s->step_expr = step;
    s->body = take(body);
    return s;
}

StmtNode* create_for_each(std::string* id, TypeNode* idType, ExprNode* container, Block* body) {
    StmtNode* s = make_stmt(StmtType::ForEach);
    s->id = take(id);
    s->id_type = idType;
    s->container_expr = container;
    s->body = take(body);
    return s;
}

StmtNode* create_while(ExprNode* condition, Block* body) {
    StmtNode* s = make_stmt(StmtType::While);
    s->condition = condition;
    s->body = take(body);
    return s;
}

StmtNode* create_do(Block* body, ExprNode* condition, bool conditionAtEnd, bool isUntil) {
    StmtNode* s = make_stmt(StmtType::Do);
    s->body = take(body);
    s->condition = condition;
    s->conditionAtEnd = conditionAtEnd;
    s->isUntil = isUntil;
    return s;
}

StmtNode* create_var_decl(VarKind kind, std::vector<VariableNode*>* declarators) {
    StmtNode* s = make_stmt(StmtType::VarDecl);
    s->var_type = kind;
    s->declarators = take(declarators);
    return s;
}
