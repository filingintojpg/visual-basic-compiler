#pragma once
#include <optional>
#include <string>
#include <utility>
#include <vector>

/* Enums */

enum class access_modifier { Public, Private, Protected };

enum class var_kind { Dim, Const };

enum class datatype_type { Integer, Boolean, Char, String, Single, UserType };

enum class expr_type {
    Int, Float, String, Char, Bool, Nothing, Id, Me, MyClass, MyBase,
    AddOp, SubOp, MulOp, DivOp, FloorDivOp, ExpOp, StrConcatOp, ModOp,
    LtOp, GtOp, LteOp, GteOp, EqOp, NeqOp,
    AndOp, AndAlsoOp, OrOp, OrElseOp, IsOp, IsNotOp,
    UnaryMinusOp, UnaryPlusOp, NotOp,
    MemberAccess, CallOrIndex, Cast,
    If, Coalesce, New, Collection
};

enum class assignment_type { Assign, AddAssign, SubAssign, MulAssign, DivAssign, FloorDivAssign, ExpAssign, StrConcatAssign };

enum class stmt_type {
    Call, Assignment, Return,
    ContinueDo, ContinueFor, ContinueWhile,
    ExitDo, ExitFor, ExitWhile, ExitSelect, ExitFunction, ExitSub,
    If, Select, For, ForEach, While, Do,
    VarDecl
};

enum class case_kind { Value, Range, Compare };

/* Base */

struct node {
    int line = 0;
    virtual ~node() = default;
};

/* Types */

struct type_node : node {
    datatype_type kind;
    std::string name;

    bool isArray = false;
    std::vector<int> dimensions = std::vector<int>();

    type_node(datatype_type kind) : kind(kind) {}
};

/* Expressions */

struct expr_node : node {
    expr_type type;

    long long intValue = 0;
    double floatValue = 0.0;
    char charValue = 0;
    bool boolValue = false;

    // String literal, ID, MemberAccess.
    std::string text;

    // Binary operators, MemberAccess, CallOrIndex, Coalesce
    expr_node* left = nullptr;
    expr_node* right = nullptr;

    // Unary operators, Cast
    expr_node* operand = nullptr;

    // If(condition, then_expr, else_expr)
    expr_node* condition = nullptr;
    expr_node* then_expr = nullptr;
    expr_node* else_expr = nullptr;

    // Cast, New
    type_node* datatype = nullptr;

    // CallOrIndex, New arguments
    std::vector<expr_node*> args;

    // Collection literal, New ... { initializer }
    std::vector<expr_node*> elements;
    bool hasInitializer = false;

    expr_node(expr_type type) : type(type) {}
};

/* Declarations shared by variables, fields and parameters */

struct typed_value : node {
    std::string name;
    type_node* type = nullptr;
    expr_node* value = nullptr;

    // "x(n) As T": type->isArray is true, these are the dimension expressions
    // (upper bounds, as in VB). Empty for plain "x() As T" parameters.
    std::vector<expr_node*> array_sizes;

    bool isOptional = false;
};

/* Statements */

struct stmt_node;

typedef std::vector<stmt_node*> block;

struct elseif_clause {
    expr_node* condition = nullptr;
    block body;
};

struct case_item {
    case_kind kind = case_kind::Value;
    expr_node* value = nullptr;
    expr_node* to = nullptr;
    expr_type op = expr_type::EqOp;
};

struct case_clause {
    std::vector<case_item> items;
    block body;
};

// One struct for all statements; which fields are used depends on `type`:
//
//   Call          expr (the call expression)
//   Assignment    lvalue, rvalue, assign_type
//   Return        expr (nullptr for bare Return)
//   Continue*/Exit*   nothing
//   If            condition, body, elseifs, else_block
//   Select        expr (subject), cases, else_block (Case Else)
//   For           id, id_type (nullable), from_expr, to_expr, step_expr (nullable), body
//   ForEach       id, id_type (nullable), container_expr, body
//   While         condition, body
//   Do            body, condition (nullptr => infinite loop),
//                 conditionAtEnd (Loop While/Until), isUntil
//   VarDecl       var_type, declarators
struct stmt_node : node {
    stmt_type type;

    expr_node* expr = nullptr;

    expr_node* lvalue = nullptr;
    expr_node* rvalue = nullptr;
    assignment_type assign_type = assignment_type::Assign;

    expr_node* condition = nullptr;
    block body;
    std::vector<elseif_clause> elseifs;
    std::optional<block> else_block;   // empty optional => no Else; Else with empty body is still engaged
    std::vector<case_clause> cases;

    std::string id;
    type_node* id_type = nullptr;
    expr_node* from_expr = nullptr;
    expr_node* to_expr = nullptr;
    expr_node* step_expr = nullptr;
    expr_node* container_expr = nullptr;

    bool conditionAtEnd = false;
    bool isUntil = false;

    var_kind var_type = var_kind::Dim;
    std::vector<typed_value*> declarators;

    stmt_node(stmt_type type) : type(type) {}
};

/* Class members */

struct procedure_node : node {
    std::string name;                    // "New" for constructors
    type_node* returnType = nullptr;     // nullptr => Sub
    std::vector<typed_value*> params;
    block body;

    access_modifier access = access_modifier::Public;
    bool isStatic = false;               // Shared
    bool isConstructor = false;          // Sub New

    bool isSub() const { return returnType == nullptr; }
};

struct field_node : node {
    access_modifier access = access_modifier::Public;
    bool isStatic = false;
    var_kind kind = var_kind::Dim;
    std::vector<typed_value*> declarators;  // Dim a, b As Integer
};

struct class_node : node {
    std::string name;
    access_modifier access = access_modifier::Public;
    std::string parent;

    std::vector<field_node*> fields;
    std::vector<procedure_node*> methods;
};

struct program_node : node {
    std::vector<class_node*> classes;
};
