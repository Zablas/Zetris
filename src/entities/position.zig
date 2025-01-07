pub const Position = struct {
    row: i32,
    column: i32,

    pub fn init(row: i32, column: i32) Position {
        return Position{
            .row = row,
            .column = column,
        };
    }
};
