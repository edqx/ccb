# CCB

The Comptime Compiler for Brainfuck. Compiles Brainfuck entirely at compile time and produces a raw executable, written in [Zig](https://ziglang.org).

It doesn't work with every Brainfuck example, because I couldn't figure out why some programs wouldn't compile.

Here are the options you can pass into `zig build`:
| Option | Required? | Description | Default Value|
|-|-|-|-|
| `-Dsource` | Yes | The source file of the brainfuck to compile | N/A |
| `-Dtape-size` | No | The number of cells available to the program to use | 4096 |
| `-Dsigned-cells` | No | Whether the cells can allow negative values | N/A |
| `-Dcell-size` | No | The size of the cells in bits for the tape | 8 |

Requires [the Zig compiler](https://ziglang.org/download/).

### Examples
Use the following commands for each of the examples:
| Example | Command | Credit |
|-|-|-|
| Fibonacci | `zig build -Dsource="examples/fibonacci.bf" -Dcell-size=16` | http://progopedia.com/example/fibonacci/14/ |
| Hello, World! | `zig build -Dsource="examples/hello-world.bf"` | https://esolangs.org/wiki/Brainfuck#Hello,_World! |
| Hello, World! (Minimal) | `zig build -Dsource="examples/minimal-hello-world.bf" -Dtape-size=256` | https://codegolf.stackexchange.com/questions/55422/hello-world/163590#163590 |
| 99 Bottles of Beer | `zig build -Dsource="examples/99-bottles-of-beer.bf"` | https://www.99-bottles-of-beer.net/language-brainfuck-101.html |
| Tic Tac Toe | `zig build -Dsource="examples/tic-tac-toe.bf"` | https://github.com/mitxela/bf-tic-tac-toe |
| Mandelbrot | `zig build -Dsource="examples/mandelbrot.bf"` | http://esoteric.sange.fi/brainfuck/utils/mandelbrot/ |

### Why?
I wanted to test Zig's compile-time capabilities.

### What?
There's no compiler or interpreter, Zig code is essentially generated based on compile-time logic, which the Zig compiler compiles naturally.

### Who?
What?
