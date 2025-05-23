const std = @import("std");

inline fn evaluateImpl(comptime CellInt: type, comptime bf: []const u8, tape: []CellInt, cursor: *usize, output_writer: anytype, input_reader: anytype) !void {
    comptime var i: usize = 0;
    inline while (i < bf.len) {
        switch (bf[i]) {
            '+' => tape[cursor.*] +%= 1,
            '-' => tape[cursor.*] -%= 1,
            '>' => {
                if (cursor.* >= tape.len - 1) cursor.* = 0 else cursor.* += 1;
            },
            '<' => {
                if (cursor.* <= 0) cursor.* = tape.len - 1 else cursor.* -= 1;
            },
            '[' => {
                const start_pos = i + 1;
                comptime {
                    var stack: usize = 0;
                    while (true) {
                        if (i >= bf.len) @compileError("Missing ']' for opening '['");
                        switch (bf[i]) {
                            '[' => stack += 1,
                            ']' => stack -= 1,
                            else => {},
                        }
                        if (stack == 0) break;
                        i += 1;
                    }
                }
                const end_pos = i;
                while (tape[cursor.*] != 0) {
                    try evaluateImpl(CellInt, bf[start_pos..end_pos], tape, cursor, output_writer, input_reader);
                }
            },
            ']' => @compileError("Missing '[' for closing ']'"),
            '.' => try output_writer.print("{c}", .{tape[cursor.*]}),
            ',' => tape[cursor.*] = @as(CellInt, @intCast(try input_reader.readByte())),
            else => {},
        }
        comptime i += 1;
    }
}

pub fn evaluate(comptime CellInt: type, comptime bf: []const u8, tape: []CellInt, output_writer: anytype, input_reader: anytype) !void {
    @setEvalBranchQuota(100_000_000);
    var cursor: usize = 0;
    try evaluateImpl(CellInt, bf, tape, &cursor, output_writer, input_reader);
}
