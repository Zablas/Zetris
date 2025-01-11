const std = @import("std");
const block = @import("block.zig");
const position = @import("position.zig");

pub const OBlock = struct {
    base: block.Block,

    pub fn init(allocator: std.mem.Allocator) !OBlock {
        var base = block.Block.init(allocator, 4);

        try base.cells.put(0, [4]position.Position{
            .{ .row = 0, .column = 0 },
            .{ .row = 0, .column = 1 },
            .{ .row = 1, .column = 0 },
            .{ .row = 1, .column = 1 },
        });

        base.move(0, 4);

        return OBlock{
            .base = base,
        };
    }
};
