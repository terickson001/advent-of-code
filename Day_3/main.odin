package main

import "core:fmt"
import "core:os"

import "../util"

main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    grid := make([dynamic]string);
    row: string;
    for
    {
        ok := read_fmt(&input, "%W%>", &row);
        
        if !ok do break;
        append(&grid, row);
    }
    
    slopes := [?][2]int{
        {1, 1},
        {3, 1},
        {5, 1},
        {7, 1},
        {1, 2},
    };
    
    res := 1;
    for slope in slopes do
        res *= check_slope(grid, slope);
    
    fmt.println(res);
}

check_slope :: proc(grid: [dynamic]string, slope: [2]int) -> int
{
    trees := 0;
    x := 0;
    y := 0;
    w := len(grid[0]);
    h := len(grid);
    for
    {
        if y >= len(grid) do break;
        if grid[y][x] == '#' do trees += 1;
        x = (x+slope.x)%w;
        y = y+slope.y;
    }
    
    return trees;
}