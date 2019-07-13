# Minilsp
Minilsp is the simple LISP interpreter. You can use specify LISP code to compile. And the grammar rules are describes in the README.md file.
and it is the NCU CSIE compiler class final project.

## Overview

LISP is an ancient programming language based on S-expressions and lambda calculus. All operations in Mini-LISP are written in parenthesized prefix notation. For example, a simple mathematical formula `(1 + 2) * 3` written in Mini-LISP is:

``` lisp
(* (+ 1 2) 3)
```

As a simplified language, Mini-LISP has only three types (Boolean, number and function) and a few operations.

## Features

### Basic Feature

In this program, I implement the Basic function of:<br/>
Syntax Validation<br/>
Print<br/>
Numerical OPerations<br/>
Logical Operations<br/>
if Expression<br/>
Variable Definition<br/>

### Bonus featires
Type Checking is implemented

## Usage
-------compile yacc------<br/>
bison -d  Minilsp.y	<br/>
gcc -c -g -I.. Minilsp.tab.c<br/>
-------compile flex------<br/>
flex  Minilsp.l<br/>
gcc -c -g -I.. lex.yy.c<br/>
-----compile and link bison and flex-----<br/>
gcc -o Minilsp Minilsp.tab.o lex.yy.o -ll<br/>
------call exe-----<br/>
./Minilsp < input.txt<br/>
## Dependencies
none
## Type Definition

Boolean: Boolean type includes two values, `#t` for true and `#f` for false.
Number: Signed integer from `-(231)` to `231 - 1`, behavior out of this range is not defined.

## Operation Overview

### Numerical Operators

|   Name   | Symbol |   Example   | Example Output |
|:--------:|:------:|:-----------:|:--------------:|
|   Plus   |   `+`  |  `(+ 1 2)`  |       `3`      |
|   Minus  |   `-`  |  `(- 1 2)`  |      `-1`      |
| Multiply |   `*`  |  `(* 2 3)`  |       `6`      |
|  Divide  |   `/`  |  `(/ 10 3)` |       `3`      |
|  Modulus |  `mod` | `(mod 8 3)` |       `2`      |
|  Greater |   `>`  |  `(> 1 2)`  |      `#f`      |
|  Smaller |   `<`  |  `(< 1 2)`  |      `#t`      |
|   Equal  |   `=`  |  `(= 1 2)`  |      `#f`      |

### Logical Operators

| Name | Symbol |    Example    | Example Output |
|:----:|:------:|:-------------:|:--------------:|
|  And |  `and` | `(and #t #f)` |      `#f`      |
|  Or  |  `or`  |  `(or #t #f)` |      `#t`      |
|  Not |  `not` |   `(not #t)`  |      `#f`      |

### Other Operators

* `define`
* `fun`
* `if`

> All operators are reserved words, you cannot use any of these words as ID.

## Lexical Details

### Preliminary Definitions

``` ebnf
separator ::= ‘\t’ | ‘\n’ | ‘\r’ | ‘ ’
letter ::= [a-z]
digit ::= [0-9]
```

### Token Definitions

``` ebnf
number ::= 0 | [1-9]digit* | -[1-9]digit*
```

Examples: `0`, `1`, `-23`, `123456`

``` ebnf
ID ::= letter (letter | digit | ‘-’)*
```

Examples: `x`, `y`, `john`, `cat-food`

``` ebnf
bool-val ::= #t | #f
```

## Grammar Overview

``` ebnf
PROGRAM ::= STMT+
STMT ::= EXP | DEF-STMT | PRINT-STMT
PRINT-STMT ::= (print-num EXP) | (print-bool EXP)
EXP ::= bool-val | number | VARIABLE | NUM-OP | LOGICAL-OP

| FUN-EXP | FUN-CALL | IF-EXP

NUM-OP ::= PLUS | MINUS | MULTIPLY | DIVIDE | MODULUS | GREATER

| SMALLER | EQUAL
PLUS ::= (+ EXP EXP+)
MINUS ::= (- EXP EXP)
MULTIPLY ::= (* EXP EXP+)
DIVIDE ::= (/ EXP EXP)
MODULUS ::= (mod EXP EXP)
GREATER ::= (> EXP EXP)
SMALLER ::= (< EXP EXP)
EQUAL ::= (= EXP EXP+)
LOGICAL-OP ::= AND-OP | OR-OP | NOT-OP
AND-OP ::= (and EXP EXP+)
OR-OP ::= (or EXP EXP+)
NOT-OP ::= (not EXP)
DEF-STMT ::= (define VARIABLE EXP)
VARIABLE ::= id
FUN-EXP ::= (fun FUN_IDs FUN-BODY)
FUN-IDs ::= (id*)
FUN-BODY ::= EXP
FUN-CALL ::= (FUN-EXP PARAM*) | (FUN-NAME PARAM*)
PARAM ::= EXP
FUN-NAME ::= id
IF-EXP ::= (if TEST-EXP THAN-EXP ELSE-EXP)
TEST-EXP ::= EXP
THEN-EXP ::= EXP
ELSE-EXP ::= EXP

## Grammar and Behavior Definition

### Program

``` ebnf
PROGRAM :: = STMT+
STMT ::= EXP | DEF-STMT | PRINT-STMT
```

### Print

``` ebnf
PRINT-STMT ::= (print-num EXP)
```

Behavior: Print `exp` in decimal.

``` ebnf
    | (print-bool EXP)
```

Behavior: Print `#t` if `EXP` is true. Print `#f`, otherwise.

### Expression (`EXP`)

``` ebnf
EXP ::= bool-val | number | VARIABLE
    | NUM-OP | LOGICAL-OP | FUN-EXP | FUN-CALL | IF-EXP
```

### Numerical Operations (`NUM-OP`)

``` ebnf
NUM-OP ::= PLUS | MINUS | MULTIPLY | DIVIDE | MODULUS |
    | GREATER | SMALLER | EQUAL
```

#### `PLUS ::= (+ EXP EXP+)`

Behavior: return sum of all `EXP` inside.

Example:

``` lisp
(+ 1 2 3 4)   ; → 10
```

#### `MINUS ::= (- EXP EXP)`

Behavior: return the result that the 1st `EXP` minus the 2nd `EXP`.

Example:

``` lisp
(- 2 1)   ; → 1
```

#### `MULTIPLY ::= (* EXP EXP+)`

Behavior: return the product of all `EXP` inside.

Example:

``` lisp
(* 1 2 3 4)   ; → 24
```

#### `DIVIDE ::= (/ EXP EXP)`

Behavior: return the result that 1st `EXP` divided by 2nd `EXP`.

Example:

``` lisp
(/ 10 5)  ; → 2
(/ 3 2)   ; → 1 (just like C++)
```

#### `MODULUS ::= (mod EXP EXP)`

Behavior: return the modulus that 1st `EXP` divided by 2nd `EXP`.

Example:

``` lisp
(mod 8 5) ; → 3
```

#### `GREATER ::= (> EXP EXP)`

Behavior: return `#t` if 1st `EXP` greater than 2nd `EXP`. `#f` otherwise.

Example:

``` lisp
(> 1 2)   ; → #f
```

#### `SMALLER ::= (< EXP EXP)`

Behavior: return `#t` if 1st `EXP` smaller than 2nd `EXP`. `#f` otherwise.

Example:

``` lisp
(< 1 2)   ; → #t
```

#### `EQUAL ::= (= EXP EXP+)`

Behavior: return `#t` if all `EXP`s are equal. `#f` otherwise.

Example:

``` lisp
(= (+ 1 1) 2 (/6 3))  ; → #t
```

### Logical Operations (`LOGICAL-OP`)

``` ebnf
LOGICAL-OP ::= AND-OP | OR-OP | NOT-OP
```

#### `AND-OP ::= (and EXP EXP+)`

Behavior: return `#t` if all `EXP`s are true. `#f` otherwise.

Example:

``` lisp
(and #t (> 2 1))  ; → #t
```

#### `OR-OP ::= (or EXP EXP+)`

Behavior: return `#t` if at least one `EXP` is true. `#f` otherwise.

Example:

``` lisp
(or (> 1 2) #f)   ; → #f
```

#### `NOT-OP ::= (not EXP)`

Behavior: return `#t` if `EXP` is false. `#f` otherwise.

Example:

``` lisp
(not (> 1 2)) ; → #t
```

### define Statement (`DEF-STMT`)

``` ebnf
DEF-STMT ::= (define id EXP)
```

``` ebnf
VARIABLE ::= id
```

Behavior: Define a variable named `id` whose value is `EXP`.

Example:

``` lisp
(define x 5)
(+ x 1)  ; → 6
```

> Note: Redefining is not allowed

### `if` Expression

``` ebnf
IF-EXP ::= (if TEST-EXP THEN-EXP ELSE-EXP)
TEST-EXP ::= EXP
THEN-EXP ::= EXP
ELSE-EXP ::= EXP
```

Behavior: When `TEST-EXP` is true, returns `THEN-EXP`. Otherwise, returns `ELSE-EXP`.

Example:

``` lisp
(if (= 1 0) 1 2)  ; → 2
(if #t 1 2)   ; → 1
```

### Type Checking

For type specifications of operations, please check out the table below:

|             Op            |       Parameter Type      |             Output Type             |
|:-------------------------:|:-------------------------:|:-----------------------------------:|
| `+`, `-`, `*`, `/`, `mod` |         Number(s)         |                Number               |
|       `<`, `>`, `=`       |         Number(s)         |               Boolean               |
|     `and`, `or`, `not`    |         Boolean(s)        |               Boolean               |
|            `if`           | Boolean(s) for `test-exp` | Depend on `then-exp` and `else-exp` |
|           `fun`           |            Any            |               Function              |
|       Function call       |            Any            | Depend on `fun-body` and parameters |

``` lisp
(> 1 #t)    ; Type Error: Expect 'number' but got 'boolean'.
```
## License
##### Fordevoted
NCU CSIE 105802015 陳昱瑋

## Conctact
2100509fssh@gmail.com
