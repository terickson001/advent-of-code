package main

import "core:fmt"
import "core:slice"
import "core:strconv"

import "../util"

input := string(#load("input"))

Item :: string;

main :: proc()
{
    using util;
    
    items := make([dynamic]Item);
    item: Item;
    for
    {
        ok := read_fmt(&input, "%s\n", &item);
        if !ok do break;
        append(&items, item);
    }
    
    part1(items[:]);
    part2(items[:]);
}

part1 :: proc(numbers: []Item)
{
    
}

part2 :: proc(numbers: []Item)
{
    
}