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

const BlockMoveState = enum {
    Normal,
    FastFalling,
    PrevFastFall,
};

pub const Game = struct {
    game_grid: grid.Grid,
    blocks: std.ArrayList(block.Block),
    current_block: block.Block = undefined,
    next_block: block.Block = undefined,
    allocator: std.mem.Allocator,
    is_game_over: bool = false,
    block_move_state: BlockMoveState = .Normal,
    score: i32 = 0,

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
        self.current_block.draw(11, 11);
        switch (self.next_block.id) {
            3 => {
                self.next_block.draw(255, 290);
            },
            4 => {
                self.next_block.draw(255, 280);
            },
            else => {
                self.next_block.draw(270, 270);
            },
        }
    }

    pub fn handleInput(self: *Game) !void {
        const key_pressed = rl.getKeyPressed();
        if (self.is_game_over and key_pressed != rl.KeyboardKey.null) {
            try self.reset();
            return;
        }

        switch (key_pressed) {
            .left => self.moveBlockLeft(),
            .right => self.moveBlockRight(),
            .up => self.rotateBlock(),
            else => {},
        }

        if (rl.isKeyReleased(rl.KeyboardKey.down)) {
            self.block_move_state = .Normal;
        }

        if (self.block_move_state != .PrevFastFall and rl.isKeyDown(rl.KeyboardKey.down)) {
            self.block_move_state = .FastFalling;
            self.updateScore(0, 1);
            try self.moveBlockDown();
        }
    }

    fn updateScore(self: *Game, lines_cleared: i32, move_down_points: i32) void {
        switch (lines_cleared) {
            1 => {
                self.score += 100;
            },
            2 => {
                self.score += 300;
            },
            3 => {
                self.score += 500;
            },
            4 => {
                self.score += 700;
            },
            else => {},
        }

        self.score += move_down_points;
    }

    fn reset(self: *Game) !void {
        self.deinit();

        self.is_game_over = false;
        self.score = 0;
        self.block_move_state = .Normal;
        self.game_grid = grid.Grid.init();
        self.blocks = try getAllBlocks(self.allocator);
        self.current_block = try self.getRandomBlock();
        self.next_block = try self.getRandomBlock();
    }

    fn moveBlockLeft(self: *Game) void {
        if (self.is_game_over) {
            return;
        }

        self.current_block.move(0, -1);
        if (self.isBlockOutside() or !self.blockFits()) {
            self.current_block.move(0, 1);
        }
    }

    fn moveBlockRight(self: *Game) void {
        if (self.is_game_over) {
            return;
        }

        self.current_block.move(0, 1);
        if (self.isBlockOutside() or !self.blockFits()) {
            self.current_block.move(0, -1);
        }
    }

    pub fn moveBlockDown(self: *Game) !void {
        if (self.is_game_over) {
            return;
        }

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
        if (self.is_game_over) {
            return;
        }

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
        self.is_game_over = !self.blockFits();
        self.next_block.deinit();
        self.next_block = try self.getRandomBlock();

        if (self.block_move_state == .FastFalling) {
            self.block_move_state = .PrevFastFall;
        }

        const rows_cleared = self.game_grid.clearFullRows();
        self.updateScore(rows_cleared, 0);
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
