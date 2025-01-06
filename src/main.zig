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

    const grid = entities.Grid.init();
    try grid.print();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colors.dark_blue);
        grid.draw();
    }
}
