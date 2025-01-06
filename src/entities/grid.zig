const std = @import("std");
const rl = @import("raylib");

pub const Grid = struct {
    grid: [20][10]usize,
    rows: i32 = 20,
    cols: i32 = 10,
    cell_size: usize = 30,
    colors: [8]rl.Color,

    pub fn init() Grid {
        return Grid{
            .grid = [_][10]usize{[_]usize{0} ** 10} ** 20,
            .colors = [8]rl.Color{
                .{ .r = 26, .g = 31, .b = 40, .a = 255 },
                .{ .r = 47, .g = 230, .b = 23, .a = 255 },
                .{ .r = 232, .g = 18, .b = 18, .a = 255 },
                .{ .r = 226, .g = 116, .b = 17, .a = 255 },
                .{ .r = 237, .g = 234, .b = 4, .a = 255 },
                .{ .r = 166, .g = 0, .b = 247, .a = 255 },
                .{ .r = 21, .g = 204, .b = 209, .a = 255 },
                .{ .r = 13, .g = 64, .b = 216, .a = 255 },
            },
        };
    }

    pub fn draw(self: Grid) void {
        for (self.grid, 0..) |row, i| {
            for (row, 0..) |cell, j| {
                if (cell < self.colors.len) {
                    rl.drawRectangle(
                        @intCast(j * self.cell_size + 1),
                        @intCast(i * self.cell_size + 1),
                        @intCast(self.cell_size - 1),
                        @intCast(self.cell_size - 1),
                        self.colors[cell],
                    );
                }
            }
        }
    }

    pub fn print(self: Grid) !void {
        const writer = std.io.getStdOut().writer();

        for (self.grid) |row| {
            for (row) |cell| {
                try writer.print("{d} ", .{cell});
            }
            try writer.print("\n", .{});
        }
    }
};
