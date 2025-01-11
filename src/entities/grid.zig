const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");

pub const Grid = struct {
    grid: [20][10]usize,
    rows: i32 = 20,
    cols: i32 = 10,
    cell_size: usize = 30,
    colors: [8]rl.Color,

    pub fn init() Grid {
        return Grid{
            .grid = [_][10]usize{[_]usize{0} ** 10} ** 20,
            .colors = constants.colors.getAllColors(),
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

    pub fn isCellOutside(self: Grid, row: i32, column: i32) bool {
        return !(row >= 0 and row < self.rows and column >= 0 and column < self.cols);
    }
};
