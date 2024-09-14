const std = @import("std");

const Hash = std.crypto.hash.sha2.Sha256;

pub const Result = union(enum) {
    ok: void,
    err: anyerror,
    mismatch: struct {
        expected: [Hash.digest_length * 2]u8,
        got: [Hash.digest_length * 2]u8,
    },
};

/// Hash contents of file at in_path and compare to expected hex hash.
pub fn check_hash(in_path: []const u8, expected: []const u8) Result {
    const in_file = std.fs.cwd().openFile(in_path, .{}) catch |err| return .{ .err = err };
    defer in_file.close();

    var in_hash: [Hash.digest_length]u8 = undefined;
    _ = std.fmt.hexToBytes(&in_hash, expected) catch |err| return .{ .err = err };

    var buf: [std.mem.page_size]u8 = undefined;
    var hasher = Hash.init(.{});
    while (true) {
        const n = in_file.read(&buf) catch |err| return .{ .err = err };
        if (n == 0) break;
        hasher.update(buf[0..n]);
    }
    const res = hasher.finalResult();

    return if (std.mem.eql(u8, &res, &in_hash)) .{ .ok = {} } else .{ .mismatch = .{
        .expected = std.fmt.bytesToHex(in_hash, .lower),
        .got = std.fmt.bytesToHex(res, .lower),
    } };
}

/// Hash contents of in_path and compare to hash in file in_hash_path.
pub fn check_hash_file(in_path: []const u8, in_hash_path: []const u8) Result {
    const in_hash_file = std.fs.cwd().openFile(in_hash_path, .{}) catch |err| return .{ .err = err };
    defer in_hash_file.close();
    var in_hash_hex: [Hash.digest_length * 2]u8 = undefined;
    _ = in_hash_file.read(&in_hash_hex) catch |err| return .{ .err = err };

    return check_hash(in_path, &in_hash_hex);
}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const args = try std.process.argsAlloc(arena);
    defer std.process.argsFree(arena, args);

    if (args.len != 3) fatal("wrong number of arguments", .{});

    const file_path = args[1];
    const hash_path = args[2];

    switch (check_hash_file(file_path, hash_path)) {
        .ok => {},
        .err => |err| {
            fatal("error checking hash of file '{s}' and hash file '{s}': {s}\n", .{
                file_path,
                hash_path,
                @errorName(err),
            });
        },
        .mismatch => |x| {
            fatal("hash mismatch:\n     expected {s}\n     got      {s}\n", .{
                &x.expected,
                &x.got,
            });
        },
    }
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
