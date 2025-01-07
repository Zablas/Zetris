const std = @import("std");
const block = @import("block.zig");
const position = @import("position.zig");

pub const IBlock = struct {
    base: block.Block,

    pub fn init(allocator: std.mem.Allocator) !IBlock {
        var base = block.Block.init(allocator, 3);

        try base.cells.put(0, [4]position.Position{
            .{ .row = 1, .column = 0 },
            .{ .row = 1, .column = 1 },
            .{ .row = 1, .column = 1 },
            .{ .row = 1, .column = 3 },
        });
        try base.cells.put(1, [4]position.Position{
            .{ .row = 0, .column = 2 },
            .{ .row = 1, .column = 2 },
            .{ .row = 2, .column = 2 },
            .{ .row = 3, .column = 2 },
        });
        try base.cells.put(2, [4]position.Position{
            .{ .row = 2, .column = 0 },
            .{ .row = 2, .column = 1 },
            .{ .row = 2, .column = 2 },
            .{ .row = 2, .column = 3 },
        });
        try base.cells.put(3, [4]position.Position{
            .{ .row = 0, .column = 1 },
            .{ .row = 1, .column = 1 },
            .{ .row = 2, .column = 1 },
            .{ .row = 3, .column = 1 },
        });

        return IBlock{
            .base = base,
        };
    }
};
