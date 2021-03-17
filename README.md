# Compiler
  A compiler written in C includes a custom Lex analyzer and Yacc parser.

The full Compiler description and requirements is in the file "language".

file.t is a general test and can be run to check the compiler works well. 

- part 1 covers - Scanner and Parser.
- part 2 covers - Lexical, full Syntax & Semantic Analysis.
- part 3 covers - previous parts and 3AC/TAC support.

The compiler is written in C, on UNIX using Visual Code.

Lex - lexical analyzer.
Yacc - parser.

contain: 
  - Lexical Analysis
  - Syntax Analysis
  - Semantic Analysis
  - Intermediate Code Generation

# Requirements: 
  Flex Bison setup.

# How to Run
	** use bash commands to run on terminal-
  *file_name = part1/part2/part3.
  *must be the same part to run.
  *fileX = any file provided on exmaples folder. 
  
  code:
      lex file_name.l
      yacc -d file_name.y --debug --verbose
      cc -o fileX y.tab.c -Ly -ll 
      ./fileX <test
