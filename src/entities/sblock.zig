const std = @import("std");
const block = @import("block.zig");
const position = @import("position.zig");

pub const SBlock = struct {
    base: block.Block,

    pub fn init(allocator: std.mem.Allocator) !SBlock {
        var base = block.Block.init(allocator, 5);

        try base.cells.put(0, [4]position.Position{
            .{ .row = 0, .column = 1 },
            .{ .row = 0, .column = 2 },
            .{ .row = 1, .column = 0 },
            .{ .row = 1, .column = 1 },
        });
        try base.cells.put(1, [4]position.Position{
            .{ .row = 0, .column = 1 },
            .{ .row = 1, .column = 1 },
            .{ .row = 1, .column = 2 },
            .{ .row = 2, .column = 2 },
        });
        try base.cells.put(2, [4]position.Position{
            .{ .row = 1, .column = 1 },
            .{ .row = 1, .column = 2 },
            .{ .row = 2, .column = 0 },
            .{ .row = 2, .column = 1 },
        });
        try base.cells.put(3, [4]position.Position{
            .{ .row = 0, .column = 0 },
            .{ .row = 1, .column = 0 },
            .{ .row = 1, .column = 1 },
            .{ .row = 2, .column = 1 },
        });

        base.move(0, 3);

        return SBlock{
            .base = base,
        };
    }
};
