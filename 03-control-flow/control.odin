Control flow statements #
for statement #

Odin has only one loop statement, the for loop.
Basic for loop #

A basic for loop has three components separated by semicolons:

    The initial statement: executed before the first iteration
    The condition expression: evaluated before every iteration
    The post statement: executed at the end of every iteration

The loop will stop executing when the condition is evaluated to false.

for i := 0; i < 10; i += 1 {
	fmt.println(i)
}

Note: Unlike other languages like C, there are no parentheses ( ) surrounding the three components. Braces { } or a do are always required.

for i := 0; i < 10; i += 1 { }
for i := 0; i < 10; i += 1 do single_statement()

The initial and post statements are optional:

i := 0
for ; i < 10; {
	i += 1
}

These semicolons can be dropped. This for loop is equivalent to C’s while loop:

i := 0
for i < 10 {
	i += 1
}

If the condition is omitted, this produces an infinite loop:

for {
}

Range-based for loop #

The basic for loop

for i := 0; i < 10; i += 1 {
	fmt.println(i)
}

can also be written

for i in 0..<10 {
	fmt.println(i)
}
// or
for i in 0..=9 {
	fmt.println(i)
}

where a..=b denotes a closed interval [a,b], i.e. the upper limit is inclusive, and a..<b denotes a half-open interval [a,b), i.e. the upper limit is exclusive.

Certain built-in types can be iterated over:

some_string := "Hello, 世界"
for character in some_string {
	fmt.println(character)
}

some_array := [3]int{1, 4, 9}
for value in some_array {
	fmt.println(value)
}

some_slice := []int{1, 4, 9}
for value in some_slice {
	fmt.println(value)
}

some_dynamic_array := [dynamic]int{1, 4, 9} // must be enabled with `#+feature dynamic-literals`
defer delete(some_dynamic_array)
for value in some_dynamic_array {
	fmt.println(value)
}

some_map := map[string]int{"A" = 1, "C" = 9, "B" = 4} // must be enabled with `#+feature dynamic-literals`
defer delete(some_map)
for key in some_map {
	fmt.println(key)
}

Alternatively a second index value can be added:

for character, index in some_string {
	fmt.println(index, character)
}
for value, index in some_array {
	fmt.println(index, value)
}
for value, index in some_slice {
	fmt.println(index, value)
}
for value, index in some_dynamic_array {
	fmt.println(index, value)
}
for key, value in some_map {
	fmt.println(key, value)
}

The iterated values are copies and cannot be written to.

When iterating a string, the characters will be runes and not bytes. for in assumes the string is encoded as UTF-8.

str: string = "Some text"
for character in str {
	assert(type_of(character) == rune)
	fmt.println(character)
}

You can iterate arrays and slices by-reference with the address operator:

for &value in some_array {
	value = something
}
for &value in some_slice {
	value = something
}
for &value in some_dynamic_array {
	value = something
}
// does not impact the second index value
for &value, index in some_dynamic_array {
	value = something
}

Map values can be iterated by-reference, but their keys cannot since map keys are immutable:

some_map := map[string]int{"A" = 1, "C" = 9, "B" = 4} // must be enabled with `#+feature dynamic-literals`
defer delete(some_map)

for key, &value in some_map {
	value += 1
}

fmt.println(some_map["A"]) // 2
fmt.println(some_map["C"]) // 10
fmt.println(some_map["B"]) // 5

Note: It is not possible to iterate a string in a by-reference manner as strings are immutable.
for reverse iteration #

The #reverse directive makes a range-based for loop iterate in reverse.

array := [?]int { 10, 20, 30, 40, 50 }

#reverse for x in array {
	fmt.println(x) // 50 40 30 20 10
}

for loop unrolling #

The #unroll directive takes a for loop and expands it at compile-time to the individual statements, repeated for as many times as the loop would normally iterate. This may result in performance improvements or provides the ability to repeat a set of instructions a limited number of times without explicitly writing each out in repetition.

Please note that #unroll may only be used with ranged for loops that have constant intervals known at compile-time.

x: [4]u8 = 0xFF
y: [4]u8 = 0x88
#unroll for i in 0..<len(x) {
	x[i] ~= y[i]
}

if statement #

Odin’s if statements do not need to be surrounded by parentheses ( ) but braces { } or do are required.

if x >= 0 {
	fmt.println("x is positive")
}

Like for, the if statement can start with an initial statement to execute before the condition. Variables declared by the initial statement are only in the scope of that if statement.

if x := foo(); x < 0 {
	fmt.println("x is negative")
}

Variables declared inside an if initial statement are also available to any of the else blocks:

if x := foo(); x < 0 {
	fmt.println("x is negative")
} else if x == 0 {
	fmt.println("x is zero")
} else {
	fmt.println("x is positive")
}

switch statement #

A switch statement is another way to write a sequence of if-else statements. In Odin, the default case is denoted as a case without any expression.

switch arch := ODIN_ARCH; arch {
case .i386, .wasm32, .arm32:
	fmt.println("32 bit")
case .amd64, .wasm64p32, .arm64, .riscv64:
	fmt.println("64 bit")
case .Unknown:
	fmt.println("Unknown architecture")
}

Odin’s switch is like the one in C or C++, except that Odin only runs the selected case. This means that a break statement is not needed at the end of each case. Another important difference is that the case values need not be integers nor constants.

To achieve a C-like fall through into the next case block, the keyword fallthrough can be used.

Switch cases are evaluated from top to bottom, stopping when a case succeeds. For example:

switch i {
case 0:
case foo():
}

foo() does not get called if i==0. If all the case values are constants, the compiler may optimize the switch statement into a jump table (like C).

A switch statement without a condition is the same as switch true. This can be used to write a clean and long if-else chain and have the ability to break if needed

switch {
case x < 0:
	fmt.println("x is negative")
case x == 0:
	fmt.println("x is zero")
case:
	fmt.println("x is positive")
}

A switch statement can also use ranges like a range-based loop:

switch c {
case 'A'..='Z', 'a'..='z', '0'..='9':
	fmt.println("c is alphanumeric")
}

switch x {
case 0..<10:
	fmt.println("units")
case 10..<13:
	fmt.println("pre-teens")
case 13..<20:
	fmt.println("teens")
case 20..<30:
	fmt.println("twenties")
}

#partial switch #

With enum values:

Foo :: enum {
	A,
	B,
	C,
	D,
}

f := Foo.A
switch f {
case .A: fmt.println("A")
case .B: fmt.println("B")
case .C: fmt.println("C")
case .D: fmt.println("D")
case:    fmt.println("?")
}

#partial switch f {
case .A: fmt.println("A")
case .D: fmt.println("D")
}

With union types (see Type switch statement)

Foo :: union {int, bool}
f: Foo = 123
switch _ in f {
case int:  fmt.println("int")
case bool: fmt.println("bool")
case:
}

#partial switch _ in f {
case bool: fmt.println("bool")
}

defer statement #

A defer statement defers the execution of a statement until the end of the scope it is in.

The following will print 4 then 234:

package main

import "core:fmt"

main :: proc() {
	x := 123
	defer fmt.println(x)
	{
		defer x = 4
		x = 2
	}
	fmt.println(x)

	x = 234
}

You can defer an entire block too:

{
	defer {
		foo()
		bar()
	}
	// This is equivalent to `defer { if cond { bar() } }` because the `if` is
	// a statement in its own right.
	defer if cond {
		bar()
	}
}

Defer statements are executed in the reverse order that they were declared:

defer fmt.println("1")
defer fmt.println("2")
defer fmt.println("3")

Will print 3, 2, and then 1.

A real world use case for defer may be something like the following:

f, err := os.open("my_file.txt")
if err != os.ERROR_NONE {
	// handle error
}
defer os.close(f)
// rest of code

In this case, it acts akin to an explicit C++ destructor however, the error handling is basic control flow.

It’s important to note that defer cannot be used to change a procedure’s named return values, as it runs after exit when the values have already been returned.

foo :: proc() -> (n: int) {
	defer {
		n = 456 // This won't affect `n`
	}
	n = 123
	return
}

Note: The defer construct in Odin differs from Go’s defer, which is function-exit and relies on a closure stack system.
when statement #

The when statement is almost identical to the if statement but with some differences:

    Each condition must be a constant expression as a when statement is evaluated at compile time.
    The statements within a branch do not create a new scope
    The compiler checks the semantics and code only for statements that belong to the first condition that is true
    An initial statement is not allowed in a when statement
    when statements are allowed at file scope

Example:

when ODIN_ARCH == .i386 {
	fmt.println("32 bit")
} else when ODIN_ARCH == .amd64 {
	fmt.println("64 bit")
} else {
	fmt.println("Unsupported architecture")
}

The when statement is very useful for writing platform specific code. This is akin to the #if construct in C’s preprocessor. However, in Odin, it is type checked.

See the Conditional compilation section for examples of built-in constants you can use with when statements.
Branch statements #
break statement #

A for loop, conditional, or a switch statement can be left prematurely with a break statement. It leaves the innermost construct, unless a label of a construct is given:

for cond {
	switch {
	case:
		if cond {
			break // break out of the `switch` statement
		}
	}

	break // break out of the `for` statement
}

loop: for cond1 {
	for cond2 {
		break loop // leaves both loops
	}
}

outer: if cond {
	ok := check_something()
	if !ok {
		break outer // label names are required with conditionals
	}
}

exit: {
    if true {
        break exit // works with labeled blocks too
    }
    fmt.println("This line will never print.")
}

continue statement #

As in many programming languages, a continue statement starts the next iteration of a loop prematurely:

for cond {
	if get_foo() {
		continue
	}
	fmt.println("Hellope")
}

fallthrough statement #

Odin’s switch is like the one in C or C++, except that Odin only runs the selected case. This means that a break statement is not needed at the end of each case. Another important difference is that the case values need not be integers nor constants.

fallthrough can be used to explicitly fall through into the next case block:

switch i {
case 0:
	foo()
	fallthrough
case 1:
	bar()
}

