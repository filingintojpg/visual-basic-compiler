#include "ast.hpp"

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>

namespace {

namespace fs = std::filesystem;

/* Names */

const char* expr_name(ExprType t) {
    switch (t) {
        case ExprType::Int: return "Int";
        case ExprType::Float: return "Float";
        case ExprType::String: return "String";
        case ExprType::Char: return "Char";
        case ExprType::Bool: return "Bool";
        case ExprType::Nothing: return "Nothing";
        case ExprType::Id: return "Id";
        case ExprType::Me: return "Me";
        case ExprType::MyClass: return "MyClass";
        case ExprType::MyBase: return "MyBase";
        case ExprType::AddOp: return "+";
        case ExprType::SubOp: return "-";
        case ExprType::MulOp: return "*";
        case ExprType::DivOp: return "/";
        case ExprType::FloorDivOp: return "\\";
        case ExprType::ExpOp: return "^";
        case ExprType::StrConcatOp: return "&";
        case ExprType::ModOp: return "Mod";
        case ExprType::LtOp: return "<";
        case ExprType::GtOp: return ">";
        case ExprType::LteOp: return "<=";
        case ExprType::GteOp: return ">=";
        case ExprType::EqOp: return "=";
        case ExprType::NeqOp: return "<>";
        case ExprType::AndOp: return "And";
        case ExprType::AndAlsoOp: return "AndAlso";
        case ExprType::OrOp: return "Or";
        case ExprType::OrElseOp: return "OrElse";
        case ExprType::IsOp: return "Is";
        case ExprType::IsNotOp: return "IsNot";
        case ExprType::UnaryMinusOp: return "Unary -";
        case ExprType::UnaryPlusOp: return "Unary +";
        case ExprType::NotOp: return "Not";
        case ExprType::MemberAccess: return "MemberAccess";
        case ExprType::CallOrIndex: return "CallOrIndex";
        case ExprType::Cast: return "Cast";
        case ExprType::If: return "If (expr)";
        case ExprType::Coalesce: return "If (coalesce)";
        case ExprType::New: return "New";
        case ExprType::Collection: return "Collection";
    }
    return "?";
}

const char* stmt_name(StmtType t) {
    switch (t) {
        case StmtType::Call: return "Call";
        case StmtType::Assignment: return "Assignment";
        case StmtType::Return: return "Return";
        case StmtType::ContinueDo: return "Continue Do";
        case StmtType::ContinueFor: return "Continue For";
        case StmtType::ContinueWhile: return "Continue While";
        case StmtType::ExitDo: return "Exit Do";
        case StmtType::ExitFor: return "Exit For";
        case StmtType::ExitWhile: return "Exit While";
        case StmtType::ExitSelect: return "Exit Select";
        case StmtType::ExitFunction: return "Exit Function";
        case StmtType::ExitSub: return "Exit Sub";
        case StmtType::If: return "If";
        case StmtType::Select: return "Select Case";
        case StmtType::For: return "For";
        case StmtType::ForEach: return "For Each";
        case StmtType::While: return "While";
        case StmtType::Do: return "Do";
        case StmtType::VarDecl: return "VarDecl";
    }
    return "?";
}

const char* access_name(AccessModifier a) {
    switch (a) {
        case AccessModifier::Public: return "Public";
        case AccessModifier::Private: return "Private";
        case AccessModifier::Protected: return "Protected";
    }
    return "?";
}

const char* data_type_name(DataType t) {
    switch (t) {
        case DataType::Integer: return "Integer";
        case DataType::Boolean: return "Boolean";
        case DataType::Char: return "Char";
        case DataType::String: return "String";
        case DataType::Single: return "Single";
        case DataType::UserType: return "";
    }
    return "?";
}

/* DOT writer */

std::string escape(const std::string& s) {
    std::string r;
    for (unsigned char c : s) {
        switch (c) {
            case '"': r += "\\\""; break;
            case '\\': r += "\\\\"; break;
            case '\n': r += "\\n"; break;
            case '\r': r += "\\r"; break;
            case '\t': r += "\\t"; break;
            default:
                if (c < 0x20) r += '?';
                else r += static_cast<char>(c);
        }
    }
    return r;
}

class DotWriter {
public:
    explicit DotWriter(std::ostream& out) : out_(out) {
        out_ << "digraph AST {\n"
             << "  node [fontname=\"DejaVu Sans\", fontsize=11];\n"
             << "  edge [fontname=\"DejaVu Sans\", fontsize=9];\n";
    }

    ~DotWriter() { out_ << "}\n"; }

    void program(const ProgramNode& p) {
        int id = node("Program", "box", "#cfe8ff");
        for (const ClassNode* c : p.classes) {
            link(id, cls(*c));
        }
    }

private:
    std::ostream& out_;
    int next_ = 0;

    int node(const std::string& label, const char* shape, const char* color) {
        int id = next_++;
        out_ << "  n" << id << " [label=\"" << escape(label) << "\", shape=" << shape
             << ", style=filled, fillcolor=\"" << color << "\"];\n";
        return id;
    }

    int structure(const std::string& label) { return node(label, "box", "#cfe8ff"); }
    int statement(const std::string& label) { return node(label, "box", "#d9f2d0"); }
    int expression(const std::string& label) { return node(label, "ellipse", "#fff2cc"); }
    int type_node(const std::string& label) { return node(label, "box", "#ead9f5"); }

    void link(int from, int to, const std::string& label = "") {
        out_ << "  n" << from << " -> n" << to;
        if (!label.empty()) out_ << " [label=\"" << escape(label) << "\"]";
        out_ << ";\n";
    }

    /* Types */

    int type(const TypeNode& t) {
        std::string label = t.kind == DataType::UserType ? t.name : data_type_name(t.kind);
        if (t.arrayRank > 0) label += "(" + std::string(t.arrayRank - 1, ',') + ")";
        return type_node(label);
    }

    /* Expressions */

    void exprs(int parent, const std::vector<ExprNode*>& list, const std::string& label) {
        if (list.empty()) return;
        int group = structure(label);
        link(parent, group);
        for (const ExprNode* e : list) link(group, expr(*e));
    }

    void opt_expr(int parent, const ExprNode* e, const std::string& label = "") {
        if (e) link(parent, expr(*e), label);
    }

    int expr(const ExprNode& e) {
        std::string label = expr_name(e.type);
        switch (e.type) {
            case ExprType::Int: label += " " + std::to_string(e.intValue); break;
            case ExprType::Float: {
                std::ostringstream ss;
                ss << e.floatValue;
                label += " " + ss.str();
                break;
            }
            case ExprType::String: label += " \"" + e.text + "\""; break;
            case ExprType::Char: label += " '" + std::string(1, e.charValue) + "'"; break;
            case ExprType::Bool: label += e.boolValue ? " True" : " False"; break;
            case ExprType::Id: label += " " + e.text; break;
            case ExprType::MemberAccess: label += " ." + e.text; break;
            default: break;
        }

        int id = expression(label);
        switch (e.type) {
            case ExprType::MemberAccess:
                opt_expr(id, e.left);
                break;
            case ExprType::CallOrIndex:
                opt_expr(id, e.left, "callee");
                exprs(id, e.args, "args");
                break;
            case ExprType::Cast:
                if (e.datatype) link(id, type(*e.datatype), "type");
                opt_expr(id, e.operand);
                break;
            case ExprType::If:
                opt_expr(id, e.condition, "cond");
                opt_expr(id, e.then_expr, "then");
                opt_expr(id, e.else_expr, "else");
                break;
            case ExprType::New:
                if (e.datatype) link(id, type(*e.datatype), "type");
                exprs(id, e.args, e.hasInitializer ? "dimensions" : "args");
                if (e.hasInitializer) {
                    int init = structure("initializer");
                    link(id, init);
                    for (const ExprNode* el : e.elements) link(init, expr(*el));
                }
                break;
            case ExprType::Collection:
                for (const ExprNode* el : e.elements) link(id, expr(*el));
                break;
            default:
                opt_expr(id, e.left, e.right ? "left" : "");
                opt_expr(id, e.right, "right");
                opt_expr(id, e.operand);
                break;
        }
        return id;
    }

    /* Variables */

    int variable(const VariableNode& v) {
        std::string label = "Variable " + v.name;
        if (v.isOptional) label = "Optional " + label;
        int id = structure(label);
        if (v.type) link(id, type(*v.type), "type");
        exprs(id, v.dimensions, "dimensions");
        opt_expr(id, v.value, v.isOptional ? "default" : "init");
        return id;
    }

    /* Statements */

    void block(int parent, const Block& b, const std::string& label) {
        if (b.empty()) return;
        int id = structure(label);
        link(parent, id);
        for (const StmtNode* s : b) link(id, stmt(*s));
    }

    int stmt(const StmtNode& s) {
        std::string label = stmt_name(s.type);
        switch (s.type) {
            case StmtType::For:
            case StmtType::ForEach: label += " " + s.id; break;
            case StmtType::VarDecl: label = s.var_type == VarKind::Const ? "Const" : "Dim"; break;
            case StmtType::Do:
                if (s.condition) {
                    label += std::string(s.isUntil ? " Until" : " While") + (s.conditionAtEnd ? " (post-test)" : " (pre-test)");
                }
                break;
            default: break;
        }

        int id = statement(label);
        switch (s.type) {
            case StmtType::Call:
            case StmtType::Return:
                opt_expr(id, s.expr);
                break;
            case StmtType::Assignment:
                opt_expr(id, s.lvalue, "target");
                opt_expr(id, s.rvalue, "value");
                break;
            case StmtType::If:
                opt_expr(id, s.condition, "cond");
                block(id, s.body, "Then");
                for (const ElseifClause& c : s.elseifs) {
                    int clause = structure("ElseIf");
                    link(id, clause);
                    opt_expr(clause, c.condition, "cond");
                    block(clause, c.body, "Body");
                }
                block(id, s.else_block, "Else");
                break;
            case StmtType::Select:
                opt_expr(id, s.expr, "subject");
                for (const CaseClause& c : s.cases) {
                    int clause = structure("Case");
                    link(id, clause);
                    for (const CaseItem& item : c.items) link(clause, case_item(item));
                    block(clause, c.body, "Body");
                }
                block(id, s.else_block, "Case Else");
                break;
            case StmtType::For:
                if (s.id_type) link(id, type(*s.id_type), "type");
                opt_expr(id, s.from_expr, "from");
                opt_expr(id, s.to_expr, "to");
                opt_expr(id, s.step_expr, "step");
                block(id, s.body, "Body");
                break;
            case StmtType::ForEach:
                if (s.id_type) link(id, type(*s.id_type), "type");
                opt_expr(id, s.container_expr, "in");
                block(id, s.body, "Body");
                break;
            case StmtType::While:
            case StmtType::Do:
                opt_expr(id, s.condition, "cond");
                block(id, s.body, "Body");
                break;
            case StmtType::VarDecl:
                for (const VariableNode* v : s.declarators) link(id, variable(*v));
                break;
            default:
                break;
        }
        return id;
    }

    int case_item(const CaseItem& c) {
        switch (c.kind) {
            case CaseKind::Value: {
                int id = structure("Value");
                opt_expr(id, c.value);
                return id;
            }
            case CaseKind::Range: {
                int id = structure("Range");
                opt_expr(id, c.value, "from");
                opt_expr(id, c.to, "to");
                return id;
            }
            case CaseKind::Compare: {
                int id = structure(std::string("Is ") + expr_name(c.op));
                opt_expr(id, c.value);
                return id;
            }
        }
        return structure("?");
    }

    /* Classes */

    int method(const MethodNode& m) {
        std::string kind = m.isConstructor ? "Constructor" : (m.isSub() ? "Sub" : "Function");
        std::string label = kind + (m.isConstructor ? "" : " " + m.name) + "\n" + access_name(m.access);
        if (m.isStatic) label += " Shared";
        int id = structure(label);
        if (m.returnType) link(id, type(*m.returnType), "returns");
        if (!m.params.empty()) {
            int params = structure("Parameters");
            link(id, params);
            for (const VariableNode* p : m.params) link(params, variable(*p));
        }
        block(id, m.body, "Body");
        return id;
    }

    int field(const FieldNode& f) {
        std::string label = std::string("Field ") + (f.kind == VarKind::Const ? "Const" : "Dim") + "\n" + access_name(f.access);
        if (f.isStatic) label += " Shared";
        int id = structure(label);
        for (const VariableNode* v : f.declarators) link(id, variable(*v));
        return id;
    }

    int cls(const ClassNode& c) {
        std::string label = "Class " + c.name + "\n" + access_name(c.access);
        if (!c.parent.empty()) label += "\nInherits " + c.parent;
        int id = structure(label);
        for (const FieldNode* f : c.fields) link(id, field(*f));
        for (const MethodNode* m : c.methods) link(id, method(*m));
        return id;
    }
};

}  // namespace

bool render_ast(const ProgramNode* program, const std::string& sourcePath, const std::string& outputDir) {
    if (!program) {
        std::cerr << "AST: nothing to render (no tree was built)" << std::endl;
        return false;
    }

    std::error_code ec;
    fs::create_directories(outputDir, ec);
    if (ec) {
        std::cerr << "AST: cannot create directory " << outputDir << ": " << ec.message() << std::endl;
        return false;
    }

    const std::string name = fs::path(sourcePath).stem().string();
    const fs::path dotPath = fs::path(outputDir) / (name + ".dot");
    const fs::path svgPath = fs::path(outputDir) / (name + ".svg");

    {
        std::ofstream dot(dotPath);
        if (!dot) {
            std::cerr << "AST: cannot write " << dotPath.string() << std::endl;
            return false;
        }
        DotWriter writer(dot);
        writer.program(*program);
    }

    const std::string cmd = "dot -Tsvg \"" + dotPath.string() + "\" -o \"" + svgPath.string() + "\"";
    if (std::system(cmd.c_str()) != 0) {
        std::cerr << "AST: Graphviz `dot` failed or is not installed; DOT file kept at " << dotPath.string() << std::endl;
        return false;
    }

    fs::remove(dotPath, ec);
    return true;
}
