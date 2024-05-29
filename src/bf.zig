const std = @import("std");

const Instruction = enum(u8) {
    left = '<',
    right = '>',
    increment = '+',
    decrement = '-',
    open_loop = '[',
    close_loop = ']',
    print_stdout = '.',
    read_stdin = ','
};

const Action = union(enum(u8)) {
    normal: Instruction,
    loop: []const Action
};

fn findCloseLoopPos(comptime bf: []const u8) ?usize {
    var depth = 0;
    return for (0.., bf) |i, character| {
        const instruction = std.meta.intToEnum(Instruction, character) catch continue;
        switch (instruction) {
            .open_loop => depth += 1,
            .close_loop => {
                if (depth == 0) break i;
                depth -= 1;
            },
            else => {}
        }
    } else null;
}

fn countIndividualActions(comptime bf: []const u8) usize {
    var num: usize = 0;
    var i = 0;
    while (i < bf.len) : (i += 1) {
        const character = bf[i];
        const instruction = std.meta.intToEnum(Instruction, character) catch continue;
        switch (instruction) {
            .left, .right, .increment, .decrement, .print_stdout, .read_stdin => num += 1,
            .open_loop => {
                num += 1;
                i += findCloseLoopPos(bf[i+1..]) orelse @compileError("Missing closing ']' to '[' at position " ++ std.fmt.comptimePrint("{d}", .{ i }));
                i += 1; // skip the actual close loop instruction
            },
            .close_loop => @compileError("Unexpected close loop ']' at position " ++ std.fmt.comptimePrint("{d}", .{ i }))
        }
    }
    return num;
}

fn getActions(comptime bf: []const u8) [countIndividualActions(bf)]Action {
    var actions: [countIndividualActions(bf)]Action = undefined;
    var i = 0;
    var j = 0;
    while (i < bf.len) : (i += 1) {
        const character = bf[i];
        const instruction = std.meta.intToEnum(Instruction, character) catch continue;
        switch (instruction) {
            .left, .right, .increment, .decrement, .print_stdout, .read_stdin => {
                actions[j] = .{ .normal = instruction };
                j += 1;
            },
            .open_loop => {
                const closeLoopPos = findCloseLoopPos(bf[i+1..]).?;
                actions[j] = .{ .loop = &getActions(bf[i+1..i+1+closeLoopPos]) };
                j += 1;
                i += closeLoopPos;
                i += 1; // skip the actual close loop instruction
            },
            .close_loop => unreachable
        }
    }
    return actions;
}

inline fn evaluateActionsImpl(comptime actions: []const Action, comptime tapeLength: usize, comptime CellInt: type, tape: [*]CellInt, cursor: *std.math.IntFittingRange(0, tapeLength), output: std.io.AnyWriter, input: std.io.AnyReader) !void {
    inline for (actions) |action| {
        switch (action) {
            .normal => |instruction| switch (instruction) {
                .left => cursor.* -%= 1,
                .right => cursor.* +%= 1,
                .increment => tape[cursor.*] +%= 1,
                .decrement => tape[cursor.*] -%= 1,
                .open_loop => unreachable,
                .close_loop => unreachable,
                .print_stdout => try output.print("{c}", .{ @as(u8, @intCast(tape[cursor.*])) }),
                .read_stdin => tape[cursor.*] = @as(CellInt, @intCast(try input.readByte()))
            },
            .loop => |subActions| while (tape[cursor.*] != 0) try evaluateActionsImpl(subActions, tapeLength, CellInt, tape, cursor, output, input)
        }
    }
}

pub fn evaluate(comptime bf: []const u8, comptime tapeLength: usize, comptime CellInt: type, tape: [*]CellInt, output: std.io.AnyWriter, input: std.io.AnyReader) !void {
    @setEvalBranchQuota(100_000_000);
    var cursor: std.math.IntFittingRange(0, tapeLength) = 0;
    try evaluateActionsImpl(&getActions(bf), tapeLength, CellInt, tape, &cursor, output, input);
}