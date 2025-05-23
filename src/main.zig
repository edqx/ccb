const std = @import("std");
const options = @import("options");
const bf = @import("./bf.zig");

pub fn main() !void {
    const CellInt = std.meta.Int(if (options.signedCells) .signed else .unsigned, options.cellSize);
    var tape: [options.tapeSize]CellInt = undefined;
    @memset(&tape, 0);
    try bf.evaluate(CellInt, @embedFile("source"), &tape, std.io.getStdOut().writer().any(), std.io.getStdIn().reader().any());
}
