const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const entities = @import("entities");

const colors = constants.colors;

pub fn main() !void {
    rl.initWindow(300, 600, "Zetris");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var game = try entities.Game.init(allocator);
    defer game.deinit();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colors.dark_blue);
        game.draw();
        game.handleInput();
    }
}
