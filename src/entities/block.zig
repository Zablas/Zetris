const std = @import("std");
const rl = @import("raylib");
const position = @import("position.zig");
const constants = @import("constants");

pub const Block = struct {
    id: usize,
    cells: std.AutoHashMap(i32, [4]position.Position),
    cell_size: i32 = 30,
    rotation_state: i32 = 0,
    colors: [8]rl.Color,

    pub fn init(allocator: std.mem.Allocator, id: usize) Block {
        const cells = std.AutoHashMap(i32, [4]position.Position).init(allocator);
        return Block{
            .id = id,
            .cells = cells,
            .colors = constants.colors.getAllColors(),
        };
    }

    pub fn deinit(self: *Block) void {
        self.cells.deinit();
    }

    pub fn draw(self: Block) void {
        const tiles = self.cells.get(self.rotation_state);
        if (tiles != null and self.id < self.colors.len) {
            for (tiles.?) |tile| {
                rl.drawRectangle(
                    tile.column * self.cell_size + 1,
                    tile.row * self.cell_size + 1,
                    self.cell_size - 1,
                    self.cell_size - 1,
                    self.colors[self.id],
                );
            }
        }
    }
};
