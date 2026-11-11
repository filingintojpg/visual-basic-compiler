#pragma once
#include <string>
#include <vector>

/* Enums */

enum class ExprType {
    Int, Float, String, Char, Bool, Nothing, Id, Me, MyClass, MyBase,
    AddOp, SubOp, MulOp, DivOp, FloorDivOp, ExpOp, StrConcatOp, ModOp,
    LtOp, GtOp, LteOp, GteOp, EqOp, NeqOp,
    AndOp, AndAlsoOp, OrOp, OrElseOp, IsOp, IsNotOp,
    UnaryMinusOp, UnaryPlusOp, NotOp,
    MemberAccess, CallOrIndex, Cast,
    If, Coalesce, New, Collection
};

enum class StmtType {
    Call, Assignment, Return,
    ContinueDo, ContinueFor, ContinueWhile,
    ExitDo, ExitFor, ExitWhile, ExitSelect, ExitFunction, ExitSub,
    If, Select, For, ForEach, While, Do,
    VarDecl
};

enum class AccessModifier { Public, Private, Protected };

enum class VarKind { Dim, Const };

enum class DataType { Integer, Boolean, Char, String, Single, UserType };

enum class CaseKind { Value, Range, Compare };

/* Base */

struct Node {
    int line = 0;
    virtual ~Node() = default;
};

/* Types */

struct TypeNode : Node {
    DataType kind;
    std::string name;

    int arrayRank = 0;

    TypeNode(DataType kind, std::string name = "") : kind(kind), name(name) {}
};

/* Expressions */

// Int                          intValue
// Float                        floatValue
// String                       text
// Char                         charValue
// Bool                         boolValue
// Nothing/Me/MyClass/MyBase
// Id                           text
// Binary ops                   left, right
// Unary ops                    operand
// MemberAccess                 left, text
// CallOrIndex                  left, args
// Cast                         datatype, operand
// If                           condition, then_expr, else_expr
// Coalesce                     left, right
// New                          datatype, args, elements, hasInitializer
// Collection                   elements
struct ExprNode : Node {
    ExprType type;

    int intValue = 0;
    float floatValue = 0.0f;
    char charValue = 0;
    bool boolValue = false;

    std::string text;

    ExprNode* left = nullptr;
    ExprNode* right = nullptr;
    ExprNode* operand = nullptr;

    ExprNode* condition = nullptr;
    ExprNode* then_expr = nullptr;
    ExprNode* else_expr = nullptr;

    TypeNode* datatype = nullptr;

    std::vector<ExprNode*> args;

    std::vector<ExprNode*> elements;
    bool hasInitializer = false;

    bool parenthesized = false;

    ExprNode(ExprType type) : type(type) {}
};

/* Variables (locals, fields, parameters) */

struct VariableNode : Node {
    std::string name;
    TypeNode* type = nullptr;
    ExprNode* value = nullptr;

    std::vector<ExprNode*> dimensions;

    bool isOptional = false;
};

/* Statements */

struct StmtNode;

typedef std::vector<StmtNode*> Block;

struct ElseifClause {
    ExprNode* condition = nullptr;
    Block body;
};

struct CaseItem {
    CaseKind kind = CaseKind::Value;
    ExprNode* value = nullptr;
    ExprNode* to = nullptr;
    ExprType op = ExprType::EqOp;
};

struct CaseClause {
    std::vector<CaseItem> items;
    Block body;
};

// Call             expr
// Assignment       lvalue, rvalue
// Return           expr
// Continue*/Exit*
// If               condition, body, elseifs, else_block
// Select           expr, cases, else_block
// For              id, id_type, from_expr, to_expr, step_expr, body
// ForEach          id, id_type, container_expr, body
// While            condition, body
// Do               body, condition, conditionAtEnd, isUntil
// VarDecl          var_type, declarators
struct StmtNode : Node {
    StmtType type;

    ExprNode* expr = nullptr;

    ExprNode* lvalue = nullptr;
    ExprNode* rvalue = nullptr;

    ExprNode* condition = nullptr;
    Block body;
    std::vector<ElseifClause> elseifs;
    Block else_block;
    std::vector<CaseClause> cases;

    std::string id;
    TypeNode* id_type = nullptr;
    ExprNode* from_expr = nullptr;
    ExprNode* to_expr = nullptr;
    ExprNode* step_expr = nullptr;
    ExprNode* container_expr = nullptr;

    bool conditionAtEnd = false;
    bool isUntil = false;

    VarKind var_type = VarKind::Dim;
    std::vector<VariableNode*> declarators;

    StmtNode(StmtType type) : type(type) {}
};

/* Class members */

struct MethodNode : Node {
    std::string name;
    TypeNode* returnType = nullptr;
    std::vector<VariableNode*> params;
    Block body;

    AccessModifier access;
    bool isStatic = false;
    bool isConstructor = false;

    bool isSub() const { return returnType == nullptr; }
};

struct FieldNode : Node {
    VarKind kind = VarKind::Dim;
    std::vector<VariableNode*> declarators;
    
    AccessModifier access;
    bool isStatic = false;
};

/* Program structure */

struct ClassNode : Node {
    std::string name;
    AccessModifier access;
    std::string parent;

    std::vector<FieldNode*> fields;
    std::vector<MethodNode*> methods;
};

struct ProgramNode : Node {
    std::vector<ClassNode*> classes;
};
