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

    pub fn isCellEmpty(self: Grid, row: i32, column: i32) bool {
        return self.grid[@intCast(row)][@intCast(column)] == 0;
    }

    pub fn clearFullRows(self: *Grid) i32 {
        var completed: i32 = 0;

        var row = self.rows - 1;
        while (row >= 0) : (row -= 1) {
            if (self.isRowFull(row)) {
                self.clearRow(row);
                completed += 1;
            } else if (completed > 0) {
                self.moveRowDown(row, completed);
            }
        }

        return completed;
    }

    fn isRowFull(self: Grid, row: i32) bool {
        for (self.grid[@intCast(row)]) |col| {
            if (col == 0) {
                return false;
            }
        }

        return true;
    }

    fn clearRow(self: *Grid, row: i32) void {
        for (&self.grid[@intCast(row)]) |*col| {
            col.* = 0;
        }
    }

    fn moveRowDown(self: *Grid, row: i32, num_rows: i32) void {
        const cols: usize = @intCast(self.cols);
        for (0..cols) |i| {
            self.grid[@intCast(row + num_rows)][i] = self.grid[@intCast(row)][i];
            self.grid[@intCast(row)][i] = 0;
        }
    }
};
