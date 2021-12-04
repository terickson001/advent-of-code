package main

import "core:fmt"
import "core:slice"

import "../util"

input := string(#load("input"))

Item :: u8;
Square :: struct
{
    n: u8,
    b: b8,
};
Board :: [25]Square;

main :: proc()
{
    using util;
    
    items := make([dynamic]Item);
    item: Item;
    for
    {
        ok := read_fmt(&input, "%v,", &item);
        append(&items, item);
        if !ok do break;
    }
    
    boards := make([dynamic]Board);
    board: Board;
    for
    {
        ok: bool;
        for i in 0..<25 do ok = read_fmt(&input, "%>%v", &board[i].n);
        if !ok do break;
        append(&boards, board);
    }
    
    copy_boards := slice.clone(boards[:]);
    part1(items[:], boards[:]);
    part2(items[:], copy_boards);
}

part1 :: proc(numbers: []Item, boards: []Board)
{
    board_num, turn := play(numbers, boards);
    res := score(boards[board_num], numbers[turn]);
    fmt.println("Part 1:", res);
}

part2 :: proc(numbers: []Item, boards: []Board)
{
    completed := util.make_bitmap(cast(u64)len(boards));
    
    board_num, turn, sub_turn: int;
    for _ in 0..<len(boards)
    {
        board_num, sub_turn = play(numbers[turn:], boards, &completed);
        turn += sub_turn;
        util.bitmap_set(&completed, cast(u64)board_num);
    }
    
    res := score(boards[board_num], numbers[turn]);
    fmt.println("Part 2:", res);
}

//

score :: proc(board: Board, number: u8) -> int
{
    sum: int;
    for s in board do if !s.b do sum += int(s.n);
    return sum * int(number);
}

mark_number :: proc(board: ^Board, n: u8) -> int
{
    for _, i in board
    {
        s := &board[i];
        if s.n == u8(n)
        {
            s.b = true;
            return i;
        }
    }
    return -1;
}

check_row :: proc(board: Board, idx: int) -> b8
{
    for i in idx*5..<idx*5+5
    {
        if !board[i].b do return false;
    }
    return true;
}

check_col :: proc(board: Board, idx: int) -> b8
{
    for i in 0..<5
    {
        if !board[i*5+idx].b do return false;
    }
    return true;
}

play :: proc(numbers: []Item, boards: []Board, completed: ^util.Bitmap = nil) -> (int, int)
{
    boards := boards;
    for n, turn in numbers
    {
        for b, i in &boards
        {
            // skip completed boards for part 2
            if completed != nil && util.bitmap_get(completed, cast(u64)i) do continue;
            
            loc := mark_number(&b, n);
            if loc == -1 do continue;
            
            won := check_row(b, loc/5);
            if !won do won = check_col(b, loc%5);
            
            if won do return i, turn;
        }
    }
    return -1, -1;
}
