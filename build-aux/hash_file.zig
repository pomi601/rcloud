const std = @import("std");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const args = try std.process.argsAlloc(arena);
    defer std.process.argsFree(arena, args);

    if (args.len != 3) fatal("wrong number of arguments", .{});

    const in_path = args[1];
    const out_path = args[2];
    var out_file = std.fs.cwd().createFile(out_path, .{}) catch |err| {
        fatal("unable to open '{s}' for writing: {s}\n", .{ out_path, @errorName(err) });
    };
    defer out_file.close();

    const in_file = std.fs.cwd().openFile(in_path, .{}) catch |err| {
        fatal("unable to open '{s}' for reading: {s}\n", .{ in_path, @errorName(err) });
    };
    defer in_file.close();

    var buf: [std.mem.page_size]u8 = undefined;
    var hasher = std.crypto.hash.sha2.Sha256.init(.{});
    while (true) {
        const n = try in_file.read(&buf);
        if (n == 0) break;
        hasher.update(buf[0..n]);
    }
    const res = hasher.finalResult();

    try out_file.writeAll(&std.fmt.bytesToHex(res, .lower));
    try std.fmt.format(out_file.writer(), "  {s}", .{in_path});
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
