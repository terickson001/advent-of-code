package main

import "core:fmt"
import "core:os"
import "core:strings"

import "../util"

Program :: [dynamic]Instruction;

Instruction :: struct
{
    kind: string,
    op: int,
    visited: b8,
}

Nop_Pred :: struct {block: ^Block, instr: int};

Block :: struct
{
    nop_predecessors: [dynamic]Nop_Pred,
    predecessors: [dynamic]^Block,
    successor: ^Block,
    start, end: int,
    idx: int,
    live: bool,
}

main :: proc()
{
    using util;
    inputb, ok := os.read_entire_file("input");
    input := string(inputb);
    
    program := make(Program);
    instr: Instruction;
    for
    {
        ok := read_fmt(&input, "%s %d%>", &instr.kind, &instr.op);
        if !ok do break;
        append(&program, instr);
    }
    
    // Build blocks
    blocks := make([dynamic]^Block);
    block: ^Block;
    start_block := true;
    for instr, pc in program
    {
        if start_block
        {
            block = new(Block);
            block.start = pc;
            block.idx = len(blocks);
            append(&blocks, block);
            start_block = false;
        }
        
        if instr.kind == "jmp"
        {
            block.end = pc;
            start_block = true;
        }
    }
    
    // Build edges
    for block in blocks
    {
        jmp := program[block.end];
        dest := block.end+jmp.op;
        successor := get_block_from_pc(blocks, dest);
        if successor == nil do continue;
        block.successor = successor;
        append(&successor.predecessors, block);
        
        for pc in block.start..<block.end
        {
            switch program[pc].kind
            {
                case "nop":
                nop := program[pc];
                dest := block.end+nop.op;
                successor := get_block_from_pc(blocks, dest);
                append(&successor.nop_predecessors, Nop_Pred{block, pc});
            }
        }
    }
    
    // Entry point is always live
    blocks[0].live = true;
    
    // Find dead blocks
    pc := 0;
    acc := 0;
    for
    {
        instr := &program[pc];
        if instr.visited do break;
        instr.visited = true;
        switch instr.kind
        {
            case "jmp":
            pc  += instr.op;
            dest := get_block_from_pc(blocks, pc);
            dest.live = true;
            
            case "acc": acc += instr.op; fallthrough;
            case "nop": pc += 1;
        }
    }
    
    // Find candidate to toggle (jmp <-> nop)
    candidate := find_candidate(blocks, blocks[len(blocks)-1]);
    assert(candidate != -1);
    switch program[candidate].kind
    {
        case "jmp": program[candidate].kind = "nop";
        case "nop": program[candidate].kind = "jmp";
    }
    
    // Run edited program
    pc = 0;
    acc = 0;
    for pc < len(program)
    {
        instr := &program[pc];
        switch instr.kind
        {
            case "jmp": pc += instr.op;
            case "acc": acc += instr.op; fallthrough;
            case "nop": pc += 1;
        }
    }
    
    fmt.println(acc);
}

// Check for a way to enter this block or one of its predecessors
find_candidate :: proc(blocks: [dynamic]^Block, block: ^Block) -> int
{
    // This shouldn't happen, but just in case
    if block.live do return -1;
    
    neighbor := blocks[block.idx-1];
    if neighbor.live do return neighbor.end; // Remove `jmp` from neighbor
    for pred in block.nop_predecessors do 
        if pred.block.live do return pred.instr; // Use `nop` to jump into this block
    
    for pred in block.predecessors
    {
        candidate := find_candidate(blocks, pred); // Check predecessors for these same conditions
        if candidate != -1 do return candidate;
    }
    return -1;
}

get_block_from_pc :: proc(blocks: [dynamic]^Block, pc: int) -> ^Block
{
    for b in blocks do
        if b.start <= pc && pc <= b.end do return b;
    return nil;
}
