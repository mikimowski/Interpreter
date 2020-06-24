# Interpreter

######################################## PSwift ########################################

Interpreter for PSwift language is composed of:
1. Typechecker responsible for handling static type control and static errors.
2. Interpreter actually executing program's instructions (only when typechecker returned success)

Interpreter can be built using 'make' command (assuming ghc version 8.6.4)
Usage:
- './interpreter program.ps': typechecks & executes given program
- './interpreter': program to be run will be read from standard input until EOF (Ctrl + D)

Most important language features:
- Simple types: int, string, bool
- List types: [int], [string], [bool]
- Tuples: composed of simple types
- Variables and functions can be redeclared
- Function parameters can be passed by both reference and value (decision is made during the call)
- Addition is well defined for: ints, strings, arrays (append)
- Other arithmetic operations are defined only for int
- Equality is well defined for all simple types and arrays
- Other relational operations are well defined for all simple types (int, string, bool)
- Lazy logical operators AND (&&) and OR (||)

BuiltIn Functions:
- print
- println
- toString(arg)

PSwift programs examples can be found in 'good' subfolder.
Programs resulting in errors can be found in 'bad' subfolder.

######################################## TypeChecker ########################################

TypeChecker parses program's tree and analyses types correctness. 
During analysis it memorizes:
    - variables' types
    - functions' types
    - information whether while loop is currently being analysed
    - type of returned value if function is being analysed


A great deal of static errors is served making programmer's life easier:

StaticErrors:
- Invalid type: expected one of ... got ...
- Index out of bound
    (only for tuples)
- Tuple index unknown
    i.e. index's value must be known in order to allow static typecheck
- Object not subscriptable
    e.g. int x; x[0];
- Invalid number of arguments: expected ... got ...
    e.g. int f(int x) {...} ... f(3, 4);
- Variable not defined: ...
    i.e. variable is not visible in current scope
- Function not defined: ...
    i.e. function is not visible in current scope
- Break outside a loop
- Continue outside a loop
- Return outside a function
- No return in function: ...
- Invalid number of values to unpack from tuple
    e.g. <int a, int b> = (1, 2, 3);
- Function arguments are not unique: ...
    e.g. int f(int x, int x) {...}

######################################## Interpreter ########################################

Interpreter traverses program's tree executing instructions one by one.
BuiltIn print and println result in output being written out immediately (stdout). 
Having encountered an error interpreter stops and returns proper infromation (stderr). 

RuntimeErrors:
- Division by zero
- Modulo by zero
- Index out of bound
