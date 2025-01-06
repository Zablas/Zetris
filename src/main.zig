const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const colors = constants.colors;

pub fn main() !void {
    rl.initWindow(300, 600, "Zetris");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colors.dark_blue);
    }
}
