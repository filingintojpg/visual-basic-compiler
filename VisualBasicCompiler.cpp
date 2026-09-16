#include <iostream>
#include <fstream>
#include <FlexLexer.h>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "File path required only" << std::endl;
        return 1;
    }

    std::ifstream file(argv[1]);
    if (!file.is_open()) {
        std::cerr << "Error opening file: " << argv[1] << std::endl;
        return 1;
    }

    yyFlexLexer lexer;
    lexer.switch_streams(&file, &std::cout);
    lexer.yylex();

    return 0;
}
