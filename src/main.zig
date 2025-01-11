const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const entities = @import("entities");

const colors = constants.colors;

pub fn main() !void {
    rl.initWindow(500, 620, "Zetris");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    const font = rl.loadFontEx("assets/fonts/monogram.ttf", 64, null);
    defer rl.unloadFont(font);

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

        rl.drawTextEx(font, "Score", .{ .x = 365, .y = 15 }, 38, 2, rl.Color.white);
        rl.drawRectangleRounded(.{ .x = 320, .y = 55, .height = 60, .width = 170 }, 0.3, 6, colors.light_blue);

        const score = rl.textFormat("%d", .{game.score});
        const text_size = rl.measureTextEx(font, score, 38, 2);
        rl.drawTextEx(
            font,
            score,
            .{ .x = 320 + @divFloor(170 - text_size.x, 2), .y = 65 },
            38,
            2,
            rl.Color.white,
        );

        rl.drawTextEx(font, "Next", .{ .x = 370, .y = 175 }, 38, 2, rl.Color.white);
        rl.drawRectangleRounded(.{ .x = 320, .y = 215, .height = 180, .width = 170 }, 0.3, 6, colors.light_blue);
        if (game.is_game_over) {
            rl.drawTextEx(font, "GAME OVER", .{ .x = 320, .y = 450 }, 38, 2, rl.Color.white);
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
