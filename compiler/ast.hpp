#pragma once
#include <string>
#include "nodes.hpp"

bool render_ast(const ProgramNode* program, const std::string& sourcePath, const std::string& outputDir = "output");
