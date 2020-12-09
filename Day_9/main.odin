package main

import "core:fmt"
import "core:os"
import "core:sort"

import "../util"

Ring :: struct(T: typeid, N: int)
{
    count: int,
    start: int,
    buf: [N]T,
}

ring_get :: proc(using ring: Ring($T, $N), idx: int) -> T
{
    idx := idx;
    assert(idx < count, "index exceeds size of ring buffer");
    idx = (start + idx) % N;
    return buf[idx];
}

ring_add :: proc(using ring: ^Ring($T, $N), val: T)
{
    if count == N do start += 1;
    if count <  N do count += 1;
    idx := (start + count - 1) % N;
    
    buf[idx] = val;
}

get_number :: proc(input: ^string) -> (int, bool)
{
    number: int;
    ok := util.read_fmt(input, "%d\n", &number);
    return number, ok;
}

main :: proc()
{
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    ring: Ring(int, 25);
    numbers: [dynamic]int;
    number: int;
    for
    {
        ok := util.read_fmt(&input, "%d\n", &number);
        if !ok do break;
        append(&numbers, number);
        if len(numbers) <= 25 do ring_add(&ring, number);
    }
    
    test: int;
    for n in numbers[25:]
    {
        test = n;
        if !ok do break;
        if !find_sum(ring, test) do break;
        ring_add(&ring, test);
    }
    
    fmt.println(test);
    
    range := find_range(numbers, test);
    sort.quick_sort(range);
    fmt.println(range[0] + range[len(range)-1]);
}

find_sum :: proc(ring: Ring(int, $N), n: int) -> bool
{
    for i in 0..<(N-1)
    {
        a := ring_get(ring, i);
        for j in (i+1)..<(N)
        {
            b := ring_get(ring, j);
            if a + b == n do return true;
        }
    }
    return false;
}

find_range :: proc(numbers: [dynamic]int, n: int) -> []int
{
    range := [2]int{0, 0};
    sum := numbers[0];
    for
    {
        if sum == n do return numbers[range[0]:range[1]+1];
        if sum > n
        {
            sum -= numbers[range[0]];
            range[0] += 1;
            for sum > n
            {
                sum -= numbers[range[1]];
                range[1] -= 1;
            }
            continue;
        }
        range[1] += 1;
        sum += numbers[range[1]];
    }
}