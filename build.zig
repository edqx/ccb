const std = @import("std");

pub fn build(b: *std.Build) void {
    const bfPath = b.option([]const u8, "source", "The source to the Brainfuck file to build") orelse {
        std.log.err("Missing Brainfuck source file, use -Dsource=<path>", .{});
        std.process.exit(1);
    };
    const tapeSize = b.option(usize, "tape-size", "The size in bytes to allocate for the tape to use for execution") orelse 4096;
    const signedCells = b.option(bool, "signed-cells", "Whether or not cells should use a signed integer and allow negative numbers") orelse false;
    const cellSize = b.option(usize, "cell-size", "The number of bits that should be allocated for each tape cell") orelse 8;

    if (tapeSize <= 0) {
        std.log.err("Tape size must be greater than 0", .{});
        std.process.exit(1);
    }

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "test",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const options = b.addOptions();
    options.addOption(usize, "tapeSize", tapeSize);
    options.addOption(bool, "signedCells", signedCells);
    options.addOption(usize, "cellSize", cellSize);

    exe.root_module.addAnonymousImport("source", .{ .root_source_file = b.path(bfPath) });
    exe.root_module.addImport("options", options.createModule());

    b.installArtifact(exe);
}
