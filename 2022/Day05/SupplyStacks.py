"""
--- Day 5: Supply Stacks ---
The expedition can depart as soon as the final supplies have been unloaded from the ships. Supplies are stored in stacks of marked crates, but because the needed supplies are buried under many other crates, the crates need to be rearranged.

The ship has a giant cargo crane capable of moving crates between stacks. To ensure none of the crates get crushed or fall over, the crane operator will rearrange them in a series of carefully-planned steps. After the crates are rearranged, the desired crates will be at the top of each stack.

The Elves don't want to interrupt the crane operator during this delicate procedure, but they forgot to ask her which crate will end up where, and they want to be ready to unload them as soon as possible so they can embark.

They do, however, have a drawing of the starting stacks of crates and the rearrangement procedure (your puzzle input). For example:

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
In this example, there are three stacks of crates. Stack 1 contains two crates: crate Z is on the bottom, and crate N is on top. Stack 2 contains three crates; from bottom to top, they are crates M, C, and D. Finally, stack 3 contains a single crate, P.

Then, the rearrangement procedure is given. In each step of the procedure, a quantity of crates is moved from one stack to a different stack. In the first step of the above rearrangement procedure, one crate is moved from stack 2 to stack 1, resulting in this configuration:

[D]        
[N] [C]    
[Z] [M] [P]
 1   2   3 
In the second step, three crates are moved from stack 1 to stack 3. Crates are moved one at a time, so the first crate to be moved (D) ends up below the second and third crates:

        [Z]
        [N]
    [C] [D]
    [M] [P]
 1   2   3
Then, both crates are moved from stack 2 to stack 1. Again, because crates are moved one at a time, crate C ends up below crate M:

        [Z]
        [N]
[M]     [D]
[C]     [P]
 1   2   3
Finally, one crate is moved from stack 1 to stack 2:

        [Z]
        [N]
        [D]
[C] [M] [P]
 1   2   3
The Elves just need to know which crate will end up on top of each stack; in this example, the top crates are C in stack 1, M in stack 2, and Z in stack 3, so you should combine these together and give the Elves the message CMZ.

After the rearrangement procedure completes, what crate ends up on top of each stack?
"""

def part1(data):
    message = ''
    stack = None
    for line in data:
        line = line[:-1] # strip the final \n
        if line.strip().startswith('['): # defining a stack
            # initialise our stack
            if not stack:
                nstacks = len(line)//3
                stack=dict([(n+1,[]) for n in range(nstacks)])
            # put items in the various queues
            for i, s in enumerate(line[1::4]):
                if s != ' ':
                    stack[int(i+1)].append(s)
        elif line.strip().startswith('1'): # all stacks defined now reverse the queues
            for s in stack:
                stack[s] = list(reversed(stack[s]))
        elif line.startswith('move'):
            pass
            _, nmoves, _ , from_stack, _, to_stack = line.split()
            for i in range(int(nmoves)):
                stack[int(to_stack)].append(stack[int(from_stack)].pop())
    for n in range(nstacks):
        if len(stack[n+1])>0:
            message += stack[n+1].pop()
    return message


def test_part1():
    data = open('test.txt').readlines()
    answer = 'CMZ'
    result = part1(data)
    if not answer == result:
        raise AssertionError(f"Part1 FAIL: answer is {answer} not {result}")
    else:
        print("Part1 PASS")
    return True


def part2(data):
    score = ''
    return score

def test_part2():
    data = open('test.txt').readlines()
    answer = None
    result = part2(data)
    if not answer == result:
        raise AssertionError(f"Part2 FAIL: answer is {answer} not {result}")
    else:
        print("Part2 PASS")
    return True


def main():
  if test_part1():
    data = open('input.txt').readlines()
    score = part1(data)
    print(f"Part 1 score is {score}")

  if test_part2():
    data = open('input.txt').readlines()
    score = part2(data)
    print(f"Part 2 score is {score}")
      
  return


if __name__ == "__main__":
  main()