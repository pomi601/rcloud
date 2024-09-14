const std = @import("std");

pub fn downloadFile(alloc: std.mem.Allocator, url: []const u8, out_path: []const u8) !void {
    const out = try downloadSlice(alloc, url);
    defer alloc.free(out);

    var out_file = try std.fs.cwd().createFile(out_path, .{});
    defer out_file.close();

    try out_file.writeAll(out);
}

/// Caller must free returned slice.
pub fn downloadSlice(alloc: std.mem.Allocator, url: []const u8) ![]u8 {
    var client = std.http.Client{ .allocator = alloc };

    var buf = std.ArrayList(u8).init(alloc);
    defer buf.deinit();

    _ = try client.fetch(.{
        .location = .{
            .url = url,
        },
        .response_storage = .{ .dynamic = &buf },
    });

    return buf.toOwnedSlice();
}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const args = try std.process.argsAlloc(arena);
    if (args.len != 3) fatal("wrong number of arguments", .{});

    const url = args[1];
    const out_path = args[2];

    // http.Client needs a thread safe allocator
    var ts_alloc_state = std.heap.ThreadSafeAllocator{ .child_allocator = arena };
    const ts_alloc = ts_alloc_state.allocator();

    downloadFile(ts_alloc, url, out_path) catch |err| {
        fatal("error downloading {s} to file '{s}': {s}\n", .{ url, out_path, @errorName(err) });
    };
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
