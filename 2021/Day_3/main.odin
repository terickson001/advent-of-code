package main

import "core:fmt"
import "core:slice"
import "core:strconv"

import "../util"

input := string(#load("input"))

main :: proc()
{
    using util;
    
    numbers := make([dynamic]string);
    number: string;
    for
    {
        ok := read_fmt(&input, "%s\n", &number);
        if !ok do break;
        append(&numbers, number);
    }
    
    slice.sort(numbers[:]);
    o2,  _  := strconv.parse_int(search(numbers[:]), 2);
    co2, _  := strconv.parse_int(search(numbers[:], true), 2);
    
    fmt.println(o2 * co2);
}

search :: proc(numbers: []string, invert := false) -> string
{
    nums := numbers;
    idx  := 0;
    
    for len(nums) > 1
    {
        zeroes := 0;
        for n in nums
        {
            if n[idx] == '0' do zeroes += 1;
        }
        test := zeroes;
        if invert do test = len(nums) - zeroes; 
        if test >= len(nums)/2 do nums = nums[:zeroes];
        else                   do nums = nums[zeroes:];
        idx += 1;
    }
    
    return nums[0];
}