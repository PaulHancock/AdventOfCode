#=
--- Day 14: Regolith Reservoir ---
The distress signal leads you to a giant waterfall! Actually, hang on - the signal seems like it's coming from the waterfall itself, and that doesn't make any sense. However, you do notice a little path that leads behind the waterfall.

Correction: the distress signal leads you behind a giant waterfall! There seems to be a large cave system here, and the signal definitely leads further inside.

As you begin to make your way deeper underground, you feel the ground rumble for a moment. Sand begins pouring into the cave! If you don't quickly figure out where the sand is going, you could quickly become trapped!

Fortunately, your familiarity with analyzing the path of falling material will come in handy here. You scan a two-dimensional vertical slice of the cave above you (your puzzle input) and discover that it is mostly air with structures made of rock.

Your scan traces the path of each solid rock structure and reports the x,y coordinates that form the shape of the path, where x represents distance to the right and y represents distance down. Each path appears as a single line of text in your scan. After the first point of each path, each point indicates the end of a straight horizontal or vertical line to be drawn from the previous point. For example:

498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
This scan means that there are two paths of rock; the first path consists of two straight lines, and the second path consists of three straight lines. (Specifically, the first path consists of a line of rock from 498,4 through 498,6 and another line of rock from 498,6 through 496,6.)

The sand is pouring into the cave from point 500,0.

Drawing rock as #, air as ., and the source of the sand as +, this becomes:


  4     5  5
  9     0  0
  4     0  3
0 ......+...
1 ..........
2 ..........
3 ..........
4 ....#...##
5 ....#...#.
6 ..###...#.
7 ........#.
8 ........#.
9 #########.
Sand is produced one unit at a time, and the next unit of sand is not produced until the previous unit of sand comes to rest. A unit of sand is large enough to fill one tile of air in your scan.

A unit of sand always falls down one step if possible. If the tile immediately below is blocked (by rock or sand), the unit of sand attempts to instead move diagonally one step down and to the left. If that tile is blocked, the unit of sand attempts to instead move diagonally one step down and to the right. Sand keeps moving as long as it is able to do so, at each step trying to move down, then down-left, then down-right. If all three possible destinations are blocked, the unit of sand comes to rest and no longer moves, at which point the next unit of sand is created back at the source.

So, drawing sand that has come to rest as o, the first unit of sand simply falls straight down and then stops:

......+...
..........
..........
..........
....#...##
....#...#.
..###...#.
........#.
......o.#.
#########.
The second unit of sand then falls straight down, lands on the first one, and then comes to rest to its left:

......+...
..........
..........
..........
....#...##
....#...#.
..###...#.
........#.
.....oo.#.
#########.
After a total of five units of sand have come to rest, they form this pattern:

......+...
..........
..........
..........
....#...##
....#...#.
..###...#.
......o.#.
....oooo#.
#########.
After a total of 22 units of sand:

......+...
..........
......o...
.....ooo..
....#ooo##
....#ooo#.
..###ooo#.
....oooo#.
...ooooo#.
#########.
Finally, only two more units of sand can possibly come to rest:

......+...
..........
......o...
.....ooo..
....#ooo##
...o#ooo#.
..###ooo#.
....oooo#.
.o.ooooo#.
#########.
Once all 24 units of sand shown above have come to rest, all further sand flows out the bottom, falling into the endless void. Just for fun, the path any new sand takes before falling forever is shown here with ~:

.......+...
.......~...
......~o...
.....~ooo..
....~#ooo##
...~o#ooo#.
..~###ooo#.
..~..oooo#.
.~o.ooooo#.
~#########.
~..........
~..........
~..........
Using your scan, simulate the falling sand. How many units of sand come to rest before sand starts flowing into the abyss below?

--- Part Two ---

You realize you misread the scan. There isn't an endless void at the bottom of the scan - there's floor, and you're standing on it!

You don't have time to scan the floor, so assume the floor is an infinite horizontal line with a y coordinate equal to two plus the highest y coordinate of any point in your scan.

In the example above, the highest y coordinate of any point is 9, and so the floor is at y=11. (This is as if your scan contained one extra rock path like -infinity,11 -> infinity,11.) With the added floor, the example above now looks like this:

        ...........+........
        ....................
        ....................
        ....................
        .........#...##.....
        .........#...#......
        .......###...#......
        .............#......
        .............#......
        .....#########......
        ....................
<-- etc #################### etc -->
To find somewhere safe to stand, you'll need to simulate falling sand until a unit of sand comes to rest at 500,0, blocking the source entirely and stopping the flow of sand into the cave. In the example above, the situation finally looks like this after 93 units of sand come to rest:

............o............
...........ooo...........
..........ooooo..........
.........ooooooo.........
........oo#ooo##o........
.......ooo#ooo#ooo.......
......oo###ooo#oooo......
.....oooo.oooo#ooooo.....
....oooooooooo#oooooo....
...ooo#########ooooooo...
..ooooo.......ooooooooo..
#########################
Using your scan, simulate the falling sand until the source of the sand becomes blocked. How many units of sand come to rest?
=#

using Logging

function gen_cave(data)
    lines =[]
    max_rows = 0
    for line in data
        # note that coords are x,y but we index arrays as y,x !
        @debug println(line)
        pairs = split(line, "->")
        points = [split(strip(p),',')[1:2] for p in pairs]
        points = [ [parse(Int,a[1]), parse(Int, a[2])]  for a in points  ]
        push!(lines, points)
        max_rows = max(max_rows, maximum([p[2] for p in points]))
    end
    @debug println("Cave has $(max_rows) rows")
    # cave = Array{Char}(undef, (1001, 10))
    cave = fill('.', (max_rows,1001))
    for points in lines
        for (s,e) in zip(points[1:end-1], points[2:end])
            @debug println("$(s) -> $(e)")
            dir1 = e[2] > s[2] ? 1 : -1
            dir2 = e[1] > s[1] ? 1 : -1
            cave[s[2]:dir1:e[2], s[1]:dir2:e[1]] .= '#'
        end
    end
    return cave
end

function step(cave,loc)
    maxrow, maxcol = size(cave)
    locations = [[loc[1]+1, loc[2]],  # down 
                 [loc[1]+1, loc[2]-1],# down left
                 [loc[1]+1, loc[2]+1]]# down right
    for l in locations
        if (1<=l[1]<=maxrow) && (1<=l[2]<=maxcol)
            if cave[l[1],l[2]] == '.'
                return l
            end
        end
    end
    return nothing # sand has no place to move
end

function drop_sand!(cave, loc)
    settled = false
    curr_loc = loc
    while ~ settled
        new_loc = step(cave,curr_loc)
        if isnothing(new_loc)
            settled = true
            cave[curr_loc[1],curr_loc[2]] = 'o'
        else
            curr_loc=new_loc
        end
    end
    maxrow = size(cave)[1]
    if curr_loc[1] < maxrow
        return false
    else
        return true
    end
end

function ppcave(cave)
    offset = 490
    for i in 1:size(cave)[1]
        println(join(cave[i,offset:offset+20]))
    end
end

function part1(data)
    cave = gen_cave(data)
    @debug ppcave(cave)
    start = [1,500]
    voided = false
    i = 0
    while ~ voided
        @debug println("dropped sand #$(i)")
        voided = drop_sand!(cave, start)
        if ~ voided
            i+=1
        end
        @debug ppcave(cave)
    end
    return i
end

function part2(data)
    return false
end

function main()
    with_logger(ConsoleLogger(stderr, Logging.Debug)) do
        @assert part1(readlines(open("test.txt"))) == 24
    end

    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 1 is $(part1(data))")
    end

    with_logger(ConsoleLogger(stderr, Logging.Debug)) do
        @assert part2(readlines(open("test.txt"))) == true
    end

    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 2 is $(part2(data))")
    end

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end