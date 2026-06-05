//
// =============================================================
//  ODIN JOURNEY — All 10 Steps in One File
//  Run any step with:  odin run odin_journey.odin -file
// =============================================================
//
// HOW TO USE THIS FILE:
//   1. Read each step top to bottom
//   2. Uncomment the step you want in main() at the bottom
//   3. Run:  odin run odin_journey.odin -file
//   4. Commit after each step:
//      git add . && git commit -m "feat(0N): <step name>"
// =============================================================

package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:os"


// =============================================================
// STEP 1 — Hellope! Packages & printing
// =============================================================
//
// KEY IDEAS:
//   package main   → every file belongs to a package
//   import         → bring in a library (core: = standard lib)
//   proc()         → a procedure (what other langs call a function)
//   ::             → permanent binding ("this name = this thing, forever")
//   fmt.println    → print a line + newline
//   fmt.printf     → print with format codes (%s %d %f %t %v)
//   fmt.printfln   → printf + automatic newline at the end
//
step1_hellope :: proc() {
    fmt.println("--- STEP 1: Hellope! ---")

    // println can take anything, separated by spaces
    fmt.println("Hellope, world!")
    fmt.println("A number:", 42)
    fmt.println("A float:", 3.14)
    fmt.println("Many things:", "hello", 99, true)

    // printf: you control the exact format
    // %s = string   %d = integer   %f = float
    // %t = bool     %v = any value (auto-detect)   \n = newline
    fmt.printf("Name: %s, Age: %d, Score: %.2f\n", "Amara", 25, 98.5)

    // printfln = printf but adds \n for you
    fmt.printfln("Pi is roughly %f", 3.14159)
    fmt.printfln("Is Odin great? %t", true)
    fmt.printfln("Anything: %v", 42)
}
// COMMIT: git commit -m "feat(01): hellope — packages, imports, fmt printing"


// =============================================================
// STEP 2 — Variables & Types
// =============================================================
//
// KEY IDEAS:
//   x: int = 5     → declare with explicit type
//   x := 5         → declare with inferred type (shorthand, most common)
//   X :: 5         → CONSTANT — cannot change, known at compile time
//   int            → platform integer (64-bit on 64-bit systems)
//   i8 i16 i32 i64 → signed integers of exact size
//   u8 u16 u32 u64 → unsigned integers (no negatives)
//   f32 f64        → floating point numbers
//   bool           → true or false
//   string         → text (immutable, UTF-8)
//   rune           → a single Unicode character (= i32 internally)
//   ---            → explicitly uninitialized (like C's garbage memory)
//   Zero values:  int=0  float=0.0  bool=false  string=""  pointer=nil
//
step2_variables :: proc() {
    fmt.println("\n--- STEP 2: Variables & Types ---")

    // --- Explicit type declaration ---
    name: string = "Amara"
    age:  int    = 25
    score: f64   = 98.5
    passed: bool = true

    fmt.printfln("Name: %s, Age: %d, Score: %.1f, Passed: %t",
                  name, age, score, passed)

    // --- Type inference with := (most common in real Odin code) ---
    city    := "Nairobi"     // inferred as string
    year    := 2026          // inferred as int
    pi      := 3.14159       // inferred as f64
    is_fun  := true          // inferred as bool

    fmt.printfln("City: %s, Year: %d, Pi: %.5f, Fun: %t",
                  city, year, pi, is_fun)

    // --- Sized integers (use when you need exact sizes, e.g. file formats) ---
    small:  i8  = 127        // -128 to 127
    medium: i32 = 2_147_483_647  // underscores for readability
    big:    i64 = 9_000_000_000
    ubyte:  u8  = 255        // 0 to 255 (no negatives)

    fmt.println("Sized ints:", small, medium, big, ubyte)

    // --- Float sizes ---
    f_small: f32 = 3.14      // 32-bit, less precision
    f_big:   f64 = 3.141592653589793  // 64-bit, more precision

    fmt.printfln("f32: %.2f  f64: %.15f", f_small, f_big)

    // --- Runes: single Unicode characters ---
    letter: rune = 'A'
    emoji:  rune = '★'
    fmt.println("Rune:", letter, "  Star:", emoji)

    // --- Constants: known at compile time, cannot change ---
    MAX_SCORE  :: 100
    APP_NAME   :: "OdinApp"
    TAX_RATE   :: 0.16       // untyped — adapts to context
    PI         : f64 : 3.14159265358979  // typed constant

    fmt.printfln("App: %s, Max: %d, Tax: %.0f%%, Pi: %.5f",
                  APP_NAME, MAX_SCORE, TAX_RATE * 100, PI)

    // --- Multiple assignment ---
    x, y := 10, 20
    fmt.println("Before swap:", x, y)
    x, y = y, x              // swap — no temp variable needed
    fmt.println("After swap: ", x, y)

    // --- Zero values: variables default to zero without explicit init ---
    zero_int:    int
    zero_float:  f64
    zero_bool:   bool
    zero_string: string
    fmt.printfln("Zeros: %d  %.1f  %t  '%s'",
                  zero_int, zero_float, zero_bool, zero_string)

    // --- Type conversion: always explicit in Odin (no silent casting!) ---
    i := 42
    f := f64(i)         // int → f64
    b := u8(f)          // f64 → u8 (truncates)
    fmt.println("Conversion:", i, "→", f, "→", b)
}
// COMMIT: git commit -m "feat(02): variables — types, constants, inference, conversion"


// =============================================================
// STEP 3 — Control Flow
// =============================================================
//
// KEY IDEAS:
//   if / else if / else   → conditional branches (no parentheses needed)
//   for                   → Odin's ONLY loop — it does everything
//     for { }             → infinite loop
//     for cond { }        → while-style loop
//     for i:=0; i<n; i+=1 → C-style loop
//     for i in 0..<n      → range loop (exclusive end)
//     for i in 0..=n      → range loop (inclusive end)
//     for v in array      → iterate values
//     for v, i in array   → iterate values + index
//   switch                → clean multi-branch (no fallthrough by default)
//   break / continue      → exit or skip loop iterations
//   defer                 → run this statement when the SCOPE exits
//                           (even if you return early — great for cleanup)
//
step3_control_flow :: proc() {
    fmt.println("\n--- STEP 3: Control Flow ---")

    // --- if / else if / else ---
    age := 20
    if age >= 18 {
        fmt.println("Adult")
    } else if age >= 13 {
        fmt.println("Teenager")
    } else {
        fmt.println("Child")
    }

    // --- if with init statement (variable lives only inside the if) ---
    if score := 85; score >= 90 {
        fmt.println("Grade: A")
    } else if score >= 75 {
        fmt.println("Grade: B")  // this runs
    } else {
        fmt.println("Grade: C")
    }

    // --- for: infinite loop with break ---
    count := 0
    for {
        count += 1
        if count >= 3 do break
    }
    fmt.println("Counted to:", count)

    // --- for: while-style ---
    n := 1
    for n < 16 {
        n *= 2
    }
    fmt.println("First power of 2 >= 16:", n)

    // --- for: C-style ---
    fmt.print("C-style:  ")
    for i := 0; i < 5; i += 1 {
        fmt.print(i, " ")
    }
    fmt.println()

    // --- for: range with exclusive end (most common) ---
    fmt.print("0..<5:    ")
    for i in 0..<5 {
        fmt.print(i, " ")
    }
    fmt.println()

    // --- for: range with inclusive end ---
    fmt.print("0..=4:    ")
    for i in 0..=4 {
        fmt.print(i, " ")
    }
    fmt.println()

    // --- continue: skip current iteration ---
    fmt.print("Odd only: ")
    for i in 0..<10 {
        if i % 2 == 0 do continue
        fmt.print(i, " ")
    }
    fmt.println()

    // --- switch: clean multi-branch, no break needed ---
    day := "Monday"
    switch day {
    case "Saturday", "Sunday":
        fmt.println("Weekend")
    case "Monday", "Tuesday", "Wednesday", "Thursday", "Friday":
        fmt.println("Weekday")   // this runs
    case:
        fmt.println("Unknown")  // default
    }

    // --- switch with no condition = cleaner if/else chain ---
    temperature := 35
    switch {
    case temperature > 30:
        fmt.println("Hot day!")   // this runs
    case temperature > 20:
        fmt.println("Nice day")
    case:
        fmt.println("Cold day")
    }

    // --- defer: runs when scope exits, in REVERSE order ---
    fmt.println("Defer demo:")
    defer fmt.println("  defer 1 — runs last")
    defer fmt.println("  defer 2 — runs second")
    fmt.println("  normal line — runs first")
    // Output order: normal line → defer 2 → defer 1
}
// COMMIT: git commit -m "feat(03): control flow — if, for, switch, defer"


// =============================================================
// STEP 4 — Procedures
// =============================================================
//
// KEY IDEAS:
//   name :: proc(param: Type) -> ReturnType { }
//   Multiple return values  → proc() -> (int, bool)
//   Named return values     → proc() -> (result: int, ok: bool)
//   Variadic params         → nums: ..int  (any number of ints)
//   Procedure groups        → explicit "overloading" in Odin
//   #force_inline           → hint to compiler to inline the call
//   Procedures are values   → you can store them in variables
//
// WHY :: for procedures?
//   :: means "constant binding" — the procedure name is a compile-time
//   constant. You can't reassign `add` to something else later.
//   := would make it a variable (valid but unusual for top-level procs).
//

// Basic procedure: takes two ints, returns an int
add :: proc(a: int, b: int) -> int {
    return a + b
}

// When params share a type, you can group them
multiply :: proc(a, b: int) -> int {
    return a * b
}

// Multiple return values — very common in Odin (no exceptions!)
divide :: proc(a, b: int) -> (result: int, ok: bool) {
    if b == 0 {
        return 0, false   // division by zero
    }
    return a / b, true
}

// Variadic: accepts any number of arguments
sum_all :: proc(nums: ..int) -> int {
    total := 0
    for n in nums {
        total += n
    }
    return total
}

// Procedure group = Odin's explicit "overloading"
greet_name :: proc(name: string) {
    fmt.printfln("Hello, %s!", name)
}
greet_nobody :: proc() {
    fmt.println("Hello, world!")
}
greet :: proc{greet_name, greet_nobody}  // group them together

// Procedures are first-class values
apply :: proc(a, b: int, operation: proc(int, int) -> int) -> int {
    return operation(a, b)
}

step4_procedures :: proc() {
    fmt.println("\n--- STEP 4: Procedures ---")

    // Basic calls
    fmt.println("3 + 4 =", add(3, 4))
    fmt.println("3 * 4 =", multiply(3, 4))

    // Multiple return values
    result, ok := divide(10, 3)
    if ok {
        fmt.println("10 / 3 =", result)
    }
    _, bad := divide(5, 0)      // _ discards a return value
    fmt.println("Divide by 0 ok?", bad)

    // Variadic
    fmt.println("Sum:", sum_all(1, 2, 3, 4, 5))
    numbers := []int{10, 20, 30}
    fmt.println("Sum slice:", sum_all(..numbers))  // spread slice into variadic

    // Procedure group (overloading)
    greet("Amara")
    greet()

    // Procedure as a value
    fmt.println("Apply add:", apply(6, 7, add))
    fmt.println("Apply mul:", apply(6, 7, multiply))

    // Anonymous (inline) procedure
    square := proc(x: int) -> int { return x * x }
    fmt.println("Square of 9:", square(9))
}
// COMMIT: git commit -m "feat(04): procedures — params, multi-return, variadic, proc groups"


// =============================================================
// STEP 5 — Arrays & Slices
// =============================================================
//
// KEY IDEAS:
//   [5]int          → fixed array, size known at compile time
//   [?]int{1,2,3}   → fixed array, size inferred from literal
//   []int           → slice: a VIEW into an array (pointer + length)
//                     slices do NOT own their memory
//   [dynamic]int    → dynamic array: can grow, owns its memory
//                     always delete() when done
//   a[low:high]     → slice of array (low inclusive, high exclusive)
//   append(&d, val) → add to dynamic array
//   len(x)          → length of array/slice/dynamic array
//   cap(x)          → capacity (dynamic arrays only)
//
step5_arrays_slices :: proc() {
    fmt.println("\n--- STEP 5: Arrays & Slices ---")

    // --- Fixed arrays ---
    scores: [5]int = {95, 87, 72, 90, 88}
    fmt.println("Scores:", scores)
    fmt.println("First:", scores[0], " Last:", scores[4])
    fmt.println("Length:", len(scores))

    // Infer size with ?
    names := [?]string{"Alice", "Bob", "Charlie"}
    fmt.println("Names:", names)

    // Modify element
    scores[2] = 80
    fmt.println("After fix:", scores)

    // Iterate values
    total := 0
    for s in scores { total += s }
    fmt.printfln("Average: %.1f", f64(total) / f64(len(scores)))

    // Iterate with index
    for s, i in scores {
        fmt.printfln("  scores[%d] = %d", i, s)
    }

    // --- Slices: views into arrays ---
    // A slice is (pointer, length) — it doesn't copy data
    all := [?]int{10, 20, 30, 40, 50}
    middle := all[1:4]     // elements 1,2,3 (not 4)
    fmt.println("All:   ", all)
    fmt.println("Middle:", middle)   // [20, 30, 40]

    from_start := all[:3]  // = all[0:3]
    to_end     := all[2:]  // = all[2:5]
    full       := all[:]   // = all[0:5]
    fmt.println("First 3:", from_start)
    fmt.println("From 2: ", to_end)
    fmt.println("Full:   ", full)

    // Modifying a slice modifies the underlying array!
    middle[0] = 999
    fmt.println("After middle[0]=999, all =", all)

    // Slice of a slice
    slice_literal := []int{1, 2, 3, 4, 5}
    fmt.println("Slice literal:", slice_literal)

    // --- Dynamic arrays: resizable, owns memory ---
    dyn: [dynamic]int
    defer delete(dyn)          // ALWAYS clean up dynamic arrays

    append(&dyn, 1)
    append(&dyn, 2, 3, 4)      // append multiple at once
    fmt.println("Dynamic:", dyn[:])
    fmt.println("Len:", len(dyn), " Cap:", cap(dyn))

    // Append a whole slice
    more := []int{5, 6, 7}
    append(&dyn, ..more)
    fmt.println("After append slice:", dyn[:])

    // Pop last element
    last := pop(&dyn)
    fmt.println("Popped:", last, " Remaining:", dyn[:])

    // ordered_remove: keeps order, O(n)
    ordered_remove(&dyn, 0)    // remove index 0
    fmt.println("After ordered_remove(0):", dyn[:])

    // unordered_remove: swaps with last, O(1) — order changes!
    unordered_remove(&dyn, 0)
    fmt.println("After unordered_remove(0):", dyn[:])

    // clear: set length to 0, keep capacity
    clear(&dyn)
    fmt.println("After clear, len:", len(dyn))
}
// COMMIT: git commit -m "feat(05): arrays & slices — fixed, slices, dynamic arrays"


// =============================================================
// STEP 6 — Structs & Pointers
// =============================================================
//
// KEY IDEAS:
//   struct          → group related data into one named type
//   ^T              → pointer to T  (Odin uses ^ not *)
//   &x              → address of x  (get a pointer to x)
//   ptr^            → dereference  (get the value a pointer points to)
//   new(T)          → allocate one T on the heap, returns ^T
//   free(ptr)       → free heap memory (always pair with new)
//   nil             → zero value for pointers (means "no address")
//   ptr.field       → access field through pointer (auto-dereferences)
//
//   WHY POINTERS?
//   By default, Odin passes structs BY VALUE (makes a copy).
//   If you want a procedure to MODIFY the original struct,
//   pass a pointer: proc(p: ^Person)  then p.age += 1
//

// Define a struct type
Person :: struct {
    name:   string,
    age:    int,
    height: f32,
}

// Takes a COPY — does not affect the original
describe :: proc(p: Person) {
    fmt.printfln("  %s is %d years old, %.1fcm tall", p.name, p.age, p.height)
}

// Takes a POINTER — modifies the original
birthday :: proc(p: ^Person) {
    p.age += 1    // p.age is shorthand for (p^).age
    fmt.printfln("  Happy birthday %s! Now %d.", p.name, p.age)
}

// Struct can contain another struct
Address :: struct {
    city:    string,
    country: string,
}
Employee :: struct {
    person:  Person,
    company: string,
    address: Address,
}

step6_structs_pointers :: proc() {
    fmt.println("\n--- STEP 6: Structs & Pointers ---")

    // --- Creating structs ---
    p1 := Person{name = "Amara", age = 25, height = 168.5}
    p2 := Person{"Bob", 30, 175.0}   // positional (order matters)
    p3 := Person{name = "Clara"}     // partial init — rest are zero values

    describe(p1)
    describe(p2)
    describe(p3)   // age=0, height=0.0

    // --- Modifying fields ---
    p1.age = 26
    fmt.println("  Updated age:", p1.age)

    // --- Pointer to struct ---
    ptr := &p1             // ptr is ^Person, points to p1
    ptr.age = 27           // same as ptr^.age = 27
    fmt.println("  Via pointer:", p1.age)   // 27 — original changed

    // --- Pass pointer to procedure ---
    birthday(&p1)
    fmt.println("  After birthday:", p1.age)  // 28

    // --- Heap allocation with new ---
    p_heap := new(Person)   // allocates on heap, returns ^Person
    defer free(p_heap)      // always free!
    p_heap.name   = "Heap Person"
    p_heap.age    = 40
    p_heap.height = 180.0
    describe(p_heap^)   // dereference to get Person value

    // --- Nested structs ---
    emp := Employee{
        person  = Person{name = "Diana", age = 32, height = 162.0},
        company = "OdinCorp",
        address = Address{city = "Nairobi", country = "Kenya"},
    }
    fmt.printfln("  %s works at %s in %s",
                  emp.person.name, emp.company, emp.address.city)

    // --- Pointer arithmetic does NOT exist in Odin (by design) ---
    // Use slices and arrays instead — much safer

    // --- nil pointer check ---
    var_ptr: ^Person = nil
    if var_ptr == nil {
        fmt.println("  Pointer is nil — safe!")
    }
}
// COMMIT: git commit -m "feat(06): structs & pointers — fields, ^T, &, new, free"


// =============================================================
// STEP 7 — Enums, Unions & Maps
// =============================================================
//
// KEY IDEAS:
//   enum           → a named set of constants (ordered, comparable)
//   .Value         → implicit selector (no need to repeat the type name)
//   union          → value that can be ONE of several types at runtime
//                    zero value is nil
//   switch _ in u  → type switch: branch on what type is stored
//   bit_set        → set of enum values stored as a bitmask (fast flags)
//   map[K]V        → hash map: keys of type K → values of type V
//                    zero value is nil — must make() before use
//                    always delete() when done
//

// Enum: ordered named constants
Direction :: enum { North, East, South, West }

// Enum with explicit backing type and values
Status :: enum u8 {
    OK      = 0,
    Warning = 1,
    Error   = 2,
}

// Union: stores exactly ONE of these types at a time
Value :: union { int, f64, string, bool }

// Bit set: a SET of enum values — great for flags/permissions
Permission :: enum { Read, Write, Execute }

step7_enums_unions_maps :: proc() {
    fmt.println("\n--- STEP 7: Enums, Unions & Maps ---")

    // --- Enums ---
    dir := Direction.North
    fmt.println("Direction:", dir)

    // Implicit selector (Odin infers the type from context)
    dir = .East
    fmt.println("Changed to:", dir)

    // Enum in a switch — must cover all cases (or use #partial)
    switch dir {
    case .North: fmt.println("  Going North")
    case .East:  fmt.println("  Going East")   // runs
    case .South: fmt.println("  Going South")
    case .West:  fmt.println("  Going West")
    }

    // Enum int value
    fmt.println("East = int", int(Direction.East))   // 1

    // Iterate ALL values of an enum
    for d in Direction {
        fmt.print(d, " ")
    }
    fmt.println()

    status := Status.OK
    fmt.println("Status:", status, "= u8", u8(status))

    // --- Unions ---
    v: Value        // starts as nil
    fmt.println("Nil union:", v)

    v = 42          // now holds an int
    v = 3.14        // now holds an f64
    v = "hello"     // now holds a string

    // Type assertion: extract value (panics if wrong type)
    s := v.(string)
    fmt.println("String from union:", s)

    // Safe assertion: returns value + ok bool
    n, ok := v.(int)
    fmt.println("Int from union:", n, "ok:", ok)  // 0, false

    // Type switch: clean way to handle all cases
    v = 100
    switch val in v {
    case int:    fmt.println("  Union holds int:", val)   // runs
    case f64:    fmt.println("  Union holds f64:", val)
    case string: fmt.println("  Union holds string:", val)
    case bool:   fmt.println("  Union holds bool:", val)
    case:        fmt.println("  Union is nil")
    }

    // --- Bit sets ---
    perms: bit_set[Permission]
    fmt.println("Empty set:", perms)

    perms += {.Read, .Write}    // add multiple
    fmt.println("After add:", perms)

    perms -= {.Write}           // remove
    fmt.println("After remove:", perms)

    fmt.println("Has Read?   ", .Read    in perms)   // true
    fmt.println("Has Write?  ", .Write   in perms)   // false
    fmt.println("Has Execute?", .Execute in perms)   // false

    // --- Maps ---
    scores := make(map[string]int)
    defer delete(scores)

    // Insert
    scores["Alice"]   = 95
    scores["Bob"]     = 87
    scores["Charlie"] = 92

    // Access
    fmt.println("Alice's score:", scores["Alice"])

    // Check if key exists (comma-ok idiom)
    val, exists := scores["Bob"]
    fmt.printfln("Bob: %d, exists: %t", val, exists)

    _, missing := scores["Nobody"]
    fmt.println("Nobody exists:", missing)   // false

    // Delete a key
    delete_key(&scores, "Bob")
    _, after := scores["Bob"]
    fmt.println("Bob after delete:", after)  // false

    // Iterate
    for name, score in scores {
        fmt.printfln("  %s → %d", name, score)
    }

    // Length
    fmt.println("Map size:", len(scores))
}
// COMMIT: git commit -m "feat(07): enums, unions, maps — types, bit_set, hash map"


// =============================================================
// STEP 8 — Error Handling
// =============================================================
//
// KEY IDEAS:
//   Odin has NO exceptions — errors are just values
//   The standard pattern: return (result, error)
//   nil means "no error" for pointers, unions, and enums with 0=OK
//
//   or_return  → if the last return value is false/non-nil, return it
//                (saves you writing if err != nil { return err })
//   or_else    → if the expression fails, use this default value
//
//   Error types you'll see:
//     (value, bool)        → ok idiom (false = something went wrong)
//     (value, ErrorEnum)   → enum where 0 = OK
//     (value, string)      → simple string error message
//

// Custom error enum (0 = OK is the Odin convention)
Parse_Error :: enum {
    None = 0,
    Empty_Input,
    Invalid_Format,
    Out_Of_Range,
}

// Returns (value, error) — classic Odin pattern
parse_age :: proc(s: string) -> (age: int, err: Parse_Error) {
    if len(s) == 0 {
        return 0, .Empty_Input
    }
    // strconv.parse_int returns (value, ok)
    n, ok := strconv.parse_int(s)
    if !ok {
        return 0, .Invalid_Format
    }
    if n < 0 || n > 150 {
        return 0, .Out_Of_Range
    }
    return n, .None   // success
}

// or_return: automatically propagates errors upward
// The caller doesn't have to write if err != nil { return 0, err }
process_user :: proc(name_str, age_str: string) -> (string, Parse_Error) {
    age := parse_age(age_str) or_return   // if error, return it immediately
    return fmt.tprintf("User %s is %d years old", name_str, age), .None
}

// or_else: provide a default if something fails
safe_divide :: proc(a, b: int) -> (int, bool) {
    if b == 0 do return 0, false
    return a / b, true
}

step8_error_handling :: proc() {
    fmt.println("\n--- STEP 8: Error Handling ---")

    // --- Basic error handling with enum ---
    age, err := parse_age("25")
    if err == .None {
        fmt.println("Parsed age:", age)
    } else {
        fmt.println("Error:", err)
    }

    _, e1 := parse_age("")
    fmt.println("Empty input error:", e1)     // Empty_Input

    _, e2 := parse_age("abc")
    fmt.println("Bad format error:", e2)      // Invalid_Format

    _, e3 := parse_age("999")
    fmt.println("Out of range error:", e3)    // Out_Of_Range

    // --- or_return propagation ---
    msg, perr := process_user("Amara", "25")
    if perr == .None {
        fmt.println(msg)
    }
    _, perr2 := process_user("Bob", "abc")
    fmt.println("process_user bad age:", perr2)  // Invalid_Format

    // --- or_else: default value on failure ---
    result := safe_divide(10, 3) or_else 0
    fmt.println("10 / 3 =", result)   // 3

    zero_div := safe_divide(10, 0) or_else -1
    fmt.println("10 / 0 =", zero_div)  // -1

    // --- Multiple error checks in sequence ---
    inputs := []string{"30", "", "200", "25"}
    for input in inputs {
        a, e := parse_age(input)
        switch e {
        case .None:         fmt.printfln("  '%s' → age %d ✓", input, a)
        case .Empty_Input:  fmt.printfln("  '%s' → empty!", input)
        case .Invalid_Format: fmt.printfln("  '%s' → bad format", input)
        case .Out_Of_Range: fmt.printfln("  '%s' → out of range", input)
        }
    }
}
// COMMIT: git commit -m "feat(08): errors — error enums, or_return, or_else"


// =============================================================
// STEP 9 — Memory & Allocators
// =============================================================
//
// KEY IDEAS:
//   Odin has NO garbage collector — YOU manage memory
//   context.allocator       → the current heap allocator
//   context.temp_allocator  → scratch memory for short-lived allocs
//   free_all(context.temp_allocator) → wipe temp memory at end of frame
//
//   new(T)          → allocate 1 value of type T on heap → ^T
//   make([]T, n)    → allocate a slice of n T values
//   make([dynamic]T)→ allocate a dynamic array
//   make(map[K]V)   → allocate a map
//   free(ptr)       → free what new() allocated
//   delete(slice/dynamic/map) → free what make() allocated
//
//   defer           → schedule cleanup at scope exit (your best friend)
//
//   Tracking allocator → debug tool that catches memory leaks
//   Always use it during development!
//

// A procedure that allocates and returns a slice
// Caller is responsible for delete()-ing the result
make_fibonacci :: proc(n: int) -> []int {
    if n <= 0 do return nil
    fibs := make([]int, n)   // caller must delete(fibs)
    fibs[0] = 0
    if n > 1 do fibs[1] = 1
    for i in 2..<n {
        fibs[i] = fibs[i-1] + fibs[i-2]
    }
    return fibs
}

step9_memory :: proc() {
    fmt.println("\n--- STEP 9: Memory & Allocators ---")

    // --- new + free ---
    p := new(int)      // heap allocate one int
    defer free(p)      // runs when step9_memory returns
    p^ = 42
    fmt.println("Heap int:", p^)

    // --- make + delete for slices ---
    buf := make([]u8, 8)
    defer delete(buf)
    for i in 0..<len(buf) { buf[i] = u8(i * 10) }
    fmt.println("Buffer:", buf)

    // --- make + delete for dynamic arrays ---
    dyn := make([dynamic]string)
    defer delete(dyn)
    append(&dyn, "hello", "world", "odin")
    fmt.println("Dynamic:", dyn[:])

    // --- make + delete for maps ---
    m := make(map[string]int)
    defer delete(m)
    m["a"] = 1
    m["b"] = 2
    fmt.println("Map:", m)

    // --- Fibonacci with caller-managed memory ---
    fibs := make_fibonacci(10)
    defer delete(fibs)   // we are the caller, so we clean up
    fmt.println("Fibonacci:", fibs)

    // --- Temp allocator for short-lived strings ---
    // temp_allocator uses an arena — free_all() wipes the whole arena at once
    // No need to free individual allocations!
    tmp := fmt.tprintf("Hello %s, you are %d years old", "Amara", 25)
    fmt.println("Temp string:", tmp)
    // tmp becomes invalid after free_all — never store it long-term
    free_all(context.temp_allocator)

    // --- Context system: change allocator for a scope ---
    // Any code inside this block uses a custom allocator
    {
        // You can swap context.allocator here for custom allocators
        // e.g. arena allocators, pool allocators, etc.
        // For now just show that context is accessible
        fmt.println("Allocator:", context.allocator)
    }

    // --- Tracking allocator (use in debug/development) ---
    // Shows you EXACTLY what leaked and where
    fmt.println("Tracking allocator demo:")
    when ODIN_DEBUG {
        // In debug mode (-debug flag), enable leak tracking:
        // track: mem.Tracking_Allocator
        // mem.tracking_allocator_init(&track, context.allocator)
        // context.allocator = mem.tracking_allocator(&track)
        // defer { ... check track.allocation_map for leaks ... }
        fmt.println("  (run with: odin run . -debug  to enable tracking)")
    } else {
        fmt.println("  (compile with -debug flag to enable tracking)")
    }

    fmt.println("Memory step done — all defers fire now:")
}
// COMMIT: git commit -m "feat(09): memory — new/free, make/delete, defer, allocators"


// =============================================================
// STEP 10 — Real Project: Mini CLI Tool
// =============================================================
//
// We build a REAL command-line task manager:
//   odin run odin_journey.odin -file -- add "Buy milk"
//   odin run odin_journey.odin -file -- list
//   odin run odin_journey.odin -file -- done 1
//
// This uses EVERYTHING from steps 1–9:
//   structs, enums, dynamic arrays, procedures,
//   error handling, memory, string handling, os.args
//

Task_Status :: enum { Pending, Done }

Task :: struct {
    id:     int,
    title:  string,
    status: Task_Status,
}

Task_List :: struct {
    tasks: [dynamic]Task,
    next_id: int,
}

// Initialize a task list (caller owns the memory)
task_list_init :: proc() -> Task_List {
    return Task_List{
        tasks   = make([dynamic]Task),
        next_id = 1,
    }
}

// Free all task list memory
task_list_destroy :: proc(tl: ^Task_List) {
    for t in tl.tasks { _ = t }  // could free individual strings here
    delete(tl.tasks)
}

// Add a task
task_add :: proc(tl: ^Task_List, title: string) -> int {
    id := tl.next_id
    append(&tl.tasks, Task{id = id, title = title, status = .Pending})
    tl.next_id += 1
    return id
}

// Mark a task done
task_done :: proc(tl: ^Task_List, id: int) -> bool {
    for &t in tl.tasks {
        if t.id == id {
            t.status = .Done
            return true
        }
    }
    return false
}

// Print all tasks
task_list_print :: proc(tl: ^Task_List) {
    if len(tl.tasks) == 0 {
        fmt.println("  No tasks yet. Add one!")
        return
    }
    for t in tl.tasks {
        marker := "[ ]" if t.status == .Pending else "[x]"
        fmt.printfln("  %s #%d: %s", marker, t.id, t.title)
    }
}

// Count pending tasks
task_count_pending :: proc(tl: ^Task_List) -> int {
    count := 0
    for t in tl.tasks {
        if t.status == .Pending do count += 1
    }
    return count
}

step10_project :: proc() {
    fmt.println("\n--- STEP 10: Mini CLI Task Manager ---")

    tl := task_list_init()
    defer task_list_destroy(&tl)

    // Simulate CLI commands
    id1 := task_add(&tl, "Learn Odin basics")
    id2 := task_add(&tl, "Build a real project")
    id3 := task_add(&tl, "Contribute to open source")
    _    = id3   // suppress unused warning

    fmt.println("Tasks after adding 3:")
    task_list_print(&tl)

    // Mark first two done
    ok1 := task_done(&tl, id1)
    ok2 := task_done(&tl, id2)
    fmt.printfln("Marked #%d done: %t", id1, ok1)
    fmt.printfln("Marked #%d done: %t", id2, ok2)

    fmt.println("\nTasks after completing 2:")
    task_list_print(&tl)

    fmt.printfln("Pending: %d / %d", task_count_pending(&tl), len(tl.tasks))

    // Try to mark non-existent task
    ok3 := task_done(&tl, 99)
    fmt.println("Mark #99 done:", ok3)  // false

    // Real CLI: read from os.args
    fmt.println("\n--- Real CLI usage ---")
    args := os.args
    fmt.println("Program:", args[0])
    if len(args) > 1 {
        cmd := args[1]
        switch cmd {
        case "add":
            if len(args) > 2 {
                new_id := task_add(&tl, args[2])
                fmt.printfln("Added task #%d: %s", new_id, args[2])
            } else {
                fmt.println("Usage: add <title>")
            }
        case "list":
            task_list_print(&tl)
        case "done":
            if len(args) > 2 {
                n, ok := strconv.parse_int(args[2])
                if ok {
                    task_done(&tl, n)
                    fmt.printfln("Marked #%d as done", n)
                }
            }
        case:
            fmt.println("Unknown command:", cmd)
        }
    } else {
        fmt.println("No CLI args — running in demo mode")
        fmt.println("Try: odin run odin_journey.odin -file -- add \"My task\"")
        fmt.println("     odin run odin_journey.odin -file -- list")
    }

    fmt.println("\nJourney complete! You now know Odin.")
}
// COMMIT: git commit -m "feat(10): project — CLI task manager using all 10 steps"


// =============================================================
// MAIN — uncomment the step you want to run
// =============================================================
main :: proc() {
    step1_hellope()
    step2_variables()
    step3_control_flow()
    step4_procedures()
    step5_arrays_slices()
    step6_structs_pointers()
    step7_enums_unions_maps()
    step8_error_handling()
    step9_memory()
    step10_project()
}