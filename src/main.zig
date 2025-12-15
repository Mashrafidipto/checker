const std = @import("std");
const fmt = std.fmt;

var stdout_buffer = [_]u8{0} ** 1024;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
var stdout = &stdout_writer.interface;

pub fn main() !void {
    var name_buffer = [_]u8{0} ** 256;

    for (0..60) |i| {
        const file_name = try fmt.bufPrint(&name_buffer, "output-{d:02}.ppm", .{i});

        var file_buffer = [_]u8{0} ** 1024;
        var fp = try std.fs.cwd().createFile(file_name, .{});
        defer fp.close();
        var file_writer = fp.writer(&file_buffer);
        var file = &file_writer.interface;

        const h, const w = .{ 9 * 60, 16 * 60 };

        try file.print("P6\n", .{});
        try file.print("{d} {d}\n", .{ w, h });
        try file.print("255\n", .{});

        for (0..h) |x| {
            for (0..w) |y| {
                if (((x + i) / 60 + (y) / 60) % 2 == 0) {
                    try file.writeByte(0x00);
                    try file.writeByte(0xff);
                    try file.writeByte(0x00);
                } else {
                    try file.writeByte(0xff);
                    try file.writeByte(0xff);
                    try file.writeByte(0xff);
                }
            }
        }
        try file.flush();
    }

    try stdout.flush();
}
