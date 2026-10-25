#include <iostream>
#include <cstdio>

extern bool DEBUG_LEXER;
extern bool DEBUG_LEXER_BY_LINE;
extern bool DEBUG_LEXER_EOL;

extern int yydebug;
extern int yyparse();
extern FILE* yyin;

extern int lexerErrors;
extern int parserErrors;

void setDebugOptions() {
    // Lexer
    DEBUG_LEXER = false;
    DEBUG_LEXER_BY_LINE = false;
    DEBUG_LEXER_EOL = false;

    // Parser
    yydebug = 1;
}

int main(int argc, char* argv[]) {
    setDebugOptions();

    if (argc != 2) {
        std::cerr << "File path required only" << std::endl;
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        std::cerr << "Error opening file: " << argv[1] << std::endl;
        return 1;
    }

    yyparse();
    fclose(yyin);
    if (lexerErrors > 0 || parserErrors > 0) {
        std::cerr << "\nCompilation failed: " << lexerErrors << " lexer error(s), " << parserErrors << " parser error(s)" << std::endl;
        return 1;
    }

    return 0;
}
