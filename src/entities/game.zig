const std = @import("std");
const rl = @import("raylib");
const grid = @import("grid.zig");
const block = @import("block.zig");

const iblock = @import("iblock.zig");
const jblock = @import("jblock.zig");
const lblock = @import("lblock.zig");
const oblock = @import("oblock.zig");
const sblock = @import("sblock.zig");
const tblock = @import("tblock.zig");
const zblock = @import("zblock.zig");

pub const Game = struct {
    game_grid: grid.Grid,
    blocks: std.ArrayList(block.Block),
    current_block: block.Block = undefined,
    next_block: block.Block = undefined,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Game {
        var game = Game{
            .game_grid = grid.Grid.init(),
            .blocks = try getAllBlocks(allocator),
            .allocator = allocator,
        };

        game.current_block = try game.getRandomBlock();
        game.next_block = try game.getRandomBlock();

        return game;
    }

    pub fn deinit(self: *Game) void {
        for (self.blocks.items) |*_block| {
            _block.deinit();
        }
        self.blocks.deinit();

        self.current_block.deinit();
        self.next_block.deinit();
    }

    pub fn getRandomBlock(self: *Game) !block.Block {
        if (self.blocks.items.len == 0) {
            self.blocks.deinit();
            self.blocks = try getAllBlocks(self.allocator);
        }

        const random_index = rl.getRandomValue(0, @intCast(self.blocks.items.len - 1));
        const _block = self.blocks.items[@intCast(random_index)];
        _ = self.blocks.swapRemove(@intCast(random_index));
        return _block;
    }

    pub fn getAllBlocks(allocator: std.mem.Allocator) !std.ArrayList(block.Block) {
        var blocks = std.ArrayList(block.Block).init(allocator);

        const _iblock = try iblock.IBlock.init(allocator);
        try blocks.append(_iblock.base);

        const _jblock = try jblock.JBlock.init(allocator);
        try blocks.append(_jblock.base);

        const _lblock = try lblock.LBlock.init(allocator);
        try blocks.append(_lblock.base);

        const _oblock = try oblock.OBlock.init(allocator);
        try blocks.append(_oblock.base);

        const _sblock = try sblock.SBlock.init(allocator);
        try blocks.append(_sblock.base);

        const _tblock = try tblock.TBlock.init(allocator);
        try blocks.append(_tblock.base);

        const _zblock = try zblock.ZBlock.init(allocator);
        try blocks.append(_zblock.base);

        return blocks;
    }

    pub fn draw(self: Game) void {
        self.game_grid.draw();
        self.current_block.draw();
    }

    pub fn handleInput(self: *Game) !void {
        switch (rl.getKeyPressed()) {
            .left => self.moveBlockLeft(),
            .right => self.moveBlockRight(),
            .down => try self.moveBlockDown(),
            .up => self.rotateBlock(),
            else => {},
        }
    }

    fn moveBlockLeft(self: *Game) void {
        self.current_block.move(0, -1);
        if (self.isBlockOutside() or !self.blockFits()) {
            self.current_block.move(0, 1);
        }
    }

    fn moveBlockRight(self: *Game) void {
        self.current_block.move(0, 1);
        if (self.isBlockOutside() or !self.blockFits()) {
            self.current_block.move(0, -1);
        }
    }

    pub fn moveBlockDown(self: *Game) !void {
        self.current_block.move(1, 0);
        if (self.isBlockOutside() or !self.blockFits()) {
            self.current_block.move(-1, 0);
            try self.lockBlock();
        }
    }

    fn isBlockOutside(self: Game) bool {
        const tiles = self.current_block.getCellPositions();
        for (tiles) |tile| {
            if (self.game_grid.isCellOutside(tile.row, tile.column)) {
                return true;
            }
        }

        return false;
    }

    fn rotateBlock(self: *Game) void {
        self.current_block.rotate();
        if (self.isBlockOutside() or !self.blockFits()) {
            self.current_block.undoRotation();
        }
    }

    fn lockBlock(self: *Game) !void {
        const tiles = self.current_block.getCellPositions();
        for (tiles) |tile| {
            self.game_grid.grid[@intCast(tile.row)][@intCast(tile.column)] = self.current_block.id;
        }

        self.current_block.deinit();
        self.current_block = try self.next_block.clone();
        self.next_block.deinit();
        self.next_block = try self.getRandomBlock();
    }

    fn blockFits(self: Game) bool {
        const tiles = self.current_block.getCellPositions();
        for (tiles) |tile| {
            if (!self.game_grid.isCellEmpty(tile.row, tile.column)) {
                return false;
            }
        }

        return true;
    }
};
