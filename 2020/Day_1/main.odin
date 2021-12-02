package main

import "core:fmt"
import "core:os"

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
    
    res := 0;
    for a,i in numbers
    {
        for b,j in numbers[i:]
        {
            for c in numbers[j:]
            {
                if (a+b+c) == 2020
                {
                    fmt.println(a*b*c);
                    return;
                }
            }
        }
    }
}
