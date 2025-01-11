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

    var last_update_time = rl.getTime();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colors.dark_blue);
        if (shouldTriggerEvent(&last_update_time, 0.2)) {
            try game.moveBlockDown();
        }
        game.draw();
        try game.handleInput();
    }
}

fn shouldTriggerEvent(last_update_time: *f64, interval: f64) bool {
    const current_time = rl.getTime();
    if (current_time - last_update_time.* >= interval) {
        last_update_time.* = current_time;
        return true;
    }
    return false;
}
