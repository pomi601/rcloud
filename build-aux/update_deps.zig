const std = @import("std");

const download_file = @import("./download_file.zig").download_file;

pub const config_path = "config.json";

const Config = struct {
    repos: []struct {
        name: []const u8,
        url: []const u8,
    },
};

const ConfigRoot = struct {
    @"update-deps": Config,
};

/// Caller should supply an arena allocator as this parse will leak memory.
pub fn read_config(alloc: std.mem.Allocator, path: []const u8) !Config {
    const config_file = try std.fs.cwd().openFile(path, .{});
    defer config_file.close();

    const buf = try config_file.readToEndAlloc(alloc, 128 * 1024);
    const root = try std.json.parseFromSliceLeaky(ConfigRoot, alloc, buf, .{
        .ignore_unknown_fields = true,
    });
    return root.@"update-deps";
}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const args = try std.process.argsAlloc(arena);
    defer std.process.argsFree(arena, args);

    if (args.len != 1) fatal("wrong number of arguments", .{});

    const config = read_config(arena, config_path) catch |err| {
        fatal("could not read config file: '{s}': {s}\n", .{ config_path, @errorName(err) });
    };

    for (config.repos) |repo| {
        std.debug.print("name: {s}\nurl:  {s}\n\n", .{ repo.name, repo.url });
    }
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
