const std = @import("std");
const rl = @import("raylib");
const position = @import("position.zig");
const constants = @import("constants");

const Position = position.Position;

pub const Block = struct {
    id: usize,
    cells: std.AutoHashMap(i32, [4]Position),
    cell_size: i32 = 30,
    rotation_state: i32 = 0,
    colors: [8]rl.Color,
    row_offset: i32 = 0,
    column_offset: i32 = 0,

    pub fn init(allocator: std.mem.Allocator, id: usize) Block {
        const cells = std.AutoHashMap(i32, [4]Position).init(allocator);
        return Block{
            .id = id,
            .cells = cells,
            .colors = constants.colors.getAllColors(),
        };
    }

    pub fn deinit(self: *Block) void {
        self.cells.deinit();
    }

    pub fn clone(self: *Block) !Block {
        return Block{
            .id = self.id,
            .cells = try self.cells.clone(),
            .cell_size = self.cell_size,
            .rotation_state = self.rotation_state,
            .colors = self.colors,
            .row_offset = self.row_offset,
            .column_offset = self.column_offset,
        };
    }

    pub fn draw(self: Block, offset_x: i32, offset_y: i32) void {
        const tiles = self.getCellPositions();
        if (self.id < self.colors.len) {
            for (tiles) |tile| {
                rl.drawRectangle(
                    tile.column * self.cell_size + offset_x,
                    tile.row * self.cell_size + offset_y,
                    self.cell_size - 1,
                    self.cell_size - 1,
                    self.colors[self.id],
                );
            }
        }
    }

    pub fn move(self: *Block, rows: i32, columns: i32) void {
        self.row_offset += rows;
        self.column_offset += columns;
    }

    pub fn getCellPositions(self: Block) [4]Position {
        const tiles = self.cells.get(self.rotation_state);
        var moved_tiles = [_]Position{Position.init(0, 0)} ** 4;
        if (tiles != null) {
            for (tiles.?, 0..) |tile, i| {
                const new_position = Position.init(tile.row + self.row_offset, tile.column + self.column_offset);
                moved_tiles[i] = new_position;
            }
        }
        return moved_tiles;
    }

    pub fn rotate(self: *Block) void {
        self.rotation_state += 1;
        const cell_count: i32 = @intCast(self.cells.count());
        self.rotation_state = @mod(self.rotation_state, cell_count);
    }

    pub fn undoRotation(self: *Block) void {
        self.rotation_state -= 1;
        if (self.rotation_state < 0) {
            self.rotation_state = @intCast(self.cells.count() - 1);
        }
    }
};
