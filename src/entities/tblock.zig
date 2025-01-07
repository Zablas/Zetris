const std = @import("std");
const block = @import("block.zig");
const position = @import("position.zig");

pub const TBlock = struct {
    base: block.Block,

    pub fn init(allocator: std.mem.Allocator) !TBlock {
        var base = block.Block.init(allocator, 6);

        try base.cells.put(0, [4]position.Position{
            .{ .row = 0, .column = 1 },
            .{ .row = 1, .column = 0 },
            .{ .row = 1, .column = 1 },
            .{ .row = 1, .column = 2 },
        });
        try base.cells.put(1, [4]position.Position{
            .{ .row = 0, .column = 1 },
            .{ .row = 1, .column = 1 },
            .{ .row = 1, .column = 2 },
            .{ .row = 2, .column = 1 },
        });
        try base.cells.put(2, [4]position.Position{
            .{ .row = 1, .column = 0 },
            .{ .row = 1, .column = 1 },
            .{ .row = 1, .column = 2 },
            .{ .row = 2, .column = 1 },
        });
        try base.cells.put(3, [4]position.Position{
            .{ .row = 0, .column = 1 },
            .{ .row = 1, .column = 0 },
            .{ .row = 1, .column = 1 },
            .{ .row = 2, .column = 1 },
        });

        return TBlock{
            .base = base,
        };
    }
};