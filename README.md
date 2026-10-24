# Visual Basic .NET Compiler

The project includes lexer, parser, semantic analysis and translation to JVM bytecode.

## Run with Docker

### Build project
```bash
docker compose build
```

### Run compiler
```bash
docker compose run --rm vb <file.vb>
```

### Run AST visualizer
```bash
docker compose run --rm ast <file.vb>
```

## Useful information

[Language Reference Manual](https://metanit.com/visualbasic/tutorial/)

[Online Visual Basic .NET Compiler](https://compilebytes.com/tools/vb)
