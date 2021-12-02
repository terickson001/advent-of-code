package main

import "core:fmt"
import "core:os"
import "core:math"

import "../util"

main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    numbers := make([dynamic]int);
    number: int;
    for
    {
        ok := read_fmt(&input, "%d\n", &number);
        if !ok do break;
        append(&numbers, number);
    }
    
    prev := math.sum(numbers[:3]);
    res := 0;
    for i in 1..<len(numbers)-2
    {
        n := math.sum(numbers[i:][:3]);
        if n > prev do res += 1;
        prev = n;
    }
    
    fmt.println(res);
}
