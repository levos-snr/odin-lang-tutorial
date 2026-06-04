

//x: int // declares ` x ` to have  type  `int`

//y, z: int //declares  `y` and `z` to have type `int`

//x := 10
//x := 20 // redeclaration  of `x`  in the scope

//y, z := 20, 30
//test, z := 20, 30 //not  allowed since `z` exists already


x: int = 123 // declares a new variable `x` with type `int` and assigns a value to it
x = 637 // assigns a new value to `x`

x, y := 1, "hello" // declares `x` and `y` and infers the types from the assignments
y, x = "bye", 5


Note: := is two tokens, : and =. The following are all equivalent:

x: int = 123
x:     = 123 // default type for an integer literal is `int`
x := 123


String and character literals #

String literals are enclosed in double quotes and character literals in single quotes. Special characters are escaped with a backslash \.

"This is a string"
'A'
'\n' // newline character
"C:\\Windows\\notepad.exe"

Raw string literals are enclosed in single back ticks.

`C:\Windows\notepad.exe`



Escape Characters #

    \a - bell (BEL)
    \b - backspace (BS)
    \e - escape (ESC)
    \f - form feed (FF)
    \n - newline
    \r - carriage return
    \t - tab
    \v - vertical tab (VT)
    \\ - backslash
    \" - double quote (if needed)
    \' - single quote (if needed)
    \NNN- octal 6 bit character (3 digits)
    \xNN - hexadecimal 8 bit character (2 digits)
    \uNNNN - hexadecimal 16-bit Unicode character UTF-8 encoded (4 digits)
    \UNNNNNNNN - hexadecimal 32-bit Unicode character UTF-8 encoded (8 digits)


x: int = 1.0 // A float literal but it can be represented by an integer without precision loss
x: int // `x` is typed as being of type `int`
x = 1 // `1` is an untyped integer literal which can implicitly convert to `int`


// A comment

my_integer_variable: int // A comment for documentation

/*
	You can have any text or code here and
	have it be commented.
	/*
		NOTE: comments can be nested!
	*/
*/


x :: "what" // constant `x` has the untyped string value "what"

y : int : 123
z :: y + 7 // constant computations are possible


import statement #

The following program imports the fmt and os packages from the core library collection.

package main

import "core:fmt"
import "core:os"

main :: proc() {
}




core: library collection.


 different import name can be used over the default package name:

import "core:fmt"
import foo "core:fmt" // reference a package by a different name





Exported names #

All declarations in a package are public by default.

The private attribute can be applied to an entity to prevent it from being exported from a package.

@(private)
my_variable: int // cannot be accessed outside this package


@(private="file")
my_variable: int // cannot be accessed outside this file


@(private) is equivalent to @(private="package").




package main. Each .odin file must have the same package name. A directory cannot contain more than 1 package.

Organizing packages #

Packages may be thematically organized by placing them in subdirectories of another package. For example: core:image/png and core:image/tga, as subdirectories of core:image. Nesting these packages is a helpful taxonomy. It does not imply a dependency: core:foo/bar does not need to import core:foo and reference anything from it.


