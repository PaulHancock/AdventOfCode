#=
--- Day 12: Hill Climbing Algorithm ---
You try contacting the Elves using your handheld device, but the river you're following must be too low to get a decent signal.

You ask the device for a heightmap of the surrounding area (your puzzle input). The heightmap shows the local area from above broken into a grid; the elevation of each square of the grid is given by a single lowercase letter, where a is the lowest elevation, b is the next-lowest, and so on up to the highest elevation, z.

Also included on the heightmap are marks for your current position (S) and the location that should get the best signal (E). Your current position (S) has elevation a, and the location that should get the best signal (E) has elevation z.

You'd like to reach E, but to save energy, you should do it in as few steps as possible. During each step, you can move exactly one square up, down, left, or right. To avoid needing to get out your climbing gear, the elevation of the destination square can be at most one higher than the elevation of your current square; that is, if your current elevation is m, you could step to elevation n, but not to elevation o. (This also means that the elevation of the destination square can be much lower than the elevation of your current square.)

For example:

Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
Here, you start in the top-left corner; your goal is near the middle. You could start by moving down or right, but eventually you'll need to head toward the e at the bottom. From there, you can spiral around to the goal:

v..v<<<<
>v.vv<<^
.>vv>E^^
..v>>>^^
..>>>>>^
In the above diagram, the symbols indicate whether the path exits each square moving up (^), down (v), left (<), or right (>). The location that should get the best signal is still E, and . marks unvisited squares.

This path reaches the goal in 31 steps, the fewest possible.

What is the fewest steps required to move from your current position to the location that should get the best signal?


--- Part Two ---
As you walk up the hill, you suspect that the Elves will want to turn this into a hiking trail. The beginning isn't very scenic, though; perhaps you can find a better starting point.

To maximize exercise while hiking, the trail should start as low as possible: elevation a. The goal is still the square marked E. However, the trail should still be direct, taking the fewest steps to reach its goal. So, you'll need to find the shortest path from any square at elevation a to the square marked E.

Again consider the example from above:

Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
Now, there are six choices for starting position (five marked a, plus the square marked S that counts as being at elevation a). If you start at the bottom-left square, you can reach the goal most quickly:

...v<<<<
...vv<<^
...v>E^^
.>v>>>^^
>^>>>>>^
This path reaches the goal in only 29 steps, the fewest possible.

What is the fewest steps required to move starting from any square with elevation a to the location that should get the best signal?
=#

using Logging

function get_neighbours(elevation, node)
    #=
    Find the neibouring nodes to the one given the size of the elevation grid
    =#
    height,width = size(elevation)
    maxnode = width*height
    neighbours=[]
    if node-width >= 1
        push!(neighbours, node-width)
    end
    if node+width <= maxnode
        push!(neighbours, node+width)
    end
    if node-1 >= 1
        push!(neighbours, node-1)
    end
    if node+1 <= maxnode
        push!(neighbours, node+1)
    end
    return neighbours
end

function pos2node(width, pos)
    node = (pos[1]-1)*width + pos[2]
    return node
end

function node2pos(width, node)
    row = div(node-1, width) +1
    col = mod(node-1, width) +1 
    return [row,col]
end
         
function part1(data)
    width = length(data[1])
    height = length(data)
    elevation = ones(Int,(height,width))
    offset = convert(Int, 'a')-1
    start = [0,0]
    goal = [0,0]
    for (i, line) in enumerate(data)
        #println(i,line)
        if 'S' in line
            index = findall('S',line)
            line = replace(line, 'S'=>'a')
            start = [i,index[1]]
        end
        if 'E' in line
            index = findall('E',line)
            line = replace(line, 'E'=>'z')
            goal = [i,index[1]]
        end
        elevation[i, begin:end] = [convert(Int,i)-offset for i in line]
    end
    println("Starting at $(start), and working towards $(goal)")
    @debug println(elevation)
    start_node = pos2node(width,start)
    goal_node = pos2node(width,goal)

    distances = ones(Int, width*height) .+ Inf
    distances[start_node] = 0
    visited = zeros(Int, width*height)

    # keep going until we reach the goal node
    while visited[goal_node] != 1
        # find the smallest distance among the not yet visited nodes
        # and choose the corresponding node as the next to work on
        curr_node = 0
        min_dist = Inf
        @debug println("distances $(distances)")
        @debug println("visited $(visited)")
        for (i,(d,v)) in enumerate(zip(distances, visited))
            if v == 0
                if d < min_dist
                    curr_node = i
                    min_dist = d
                end
            end
        end
        # thid node position
        tnpos = node2pos(width, curr_node)
        @debug println("looking at node $(curr_node) at $(tnpos)")
        for n in get_neighbours(elevation, curr_node)
            # neighbour node position
            nnpos = node2pos(width, n)
            if visited[n] == 0
                @debug println(" looking at neighbour $(n) at  $(nnpos)")
                diff = elevation[nnpos[1],nnpos[2]] - elevation[tnpos[1],tnpos[2]]
                # if the difference in elevation is at most 1 then we can make a single step
                if diff <=1
                    @debug println("  potential step")
                    distances[n] = min(distances[n], distances[curr_node]+1)
                end
            end
        end
        visited[curr_node] = 1
    end
    println("shortest distances is $(distances[goal_node])")
    return distances[goal_node]
end

function part2(data)
    width = length(data[1])
    height = length(data)
    elevation = ones(Int,(height,width))
    offset = convert(Int, 'a')-1
    starts = []
    goal = [0,0]
    for (i, line) in enumerate(data)
        #println(i,line)
        if 'S' in line
            index = findall('S',line)
            line = replace(line, 'S'=>'a')
        end
        if 'E' in line
            index = findall('E',line)
            line = replace(line, 'E'=>'z')
            goal = [i,index[1]]
        end
        for j in findall('a',line)
            push!(starts,[i, j[1]])
        end
        elevation[i, begin:end] = [convert(Int,i)-offset for i in line]
    end

    best_start = nothing
    best_dist = Inf
    for start in starts
        println("Starting at $(start), and working towards $(goal)")
        @debug println(elevation)
        start_node = pos2node(width,start)
        goal_node = pos2node(width,goal)

        distances = ones(Int, width*height) .+ Inf
        distances[start_node] = 0
        visited = zeros(Int, width*height)

        # keep going until we reach the goal node
        while visited[goal_node] != 1
            # find the smallest distance among the not yet visited nodes
            # and choose the corresponding node as the next to work on
            curr_node = 0
            min_dist = Inf
            @debug println("distances $(distances)")
            @debug println("visited $(visited)")
            for (i,(d,v)) in enumerate(zip(distances, visited))
                if v == 0
                    if d < min_dist
                        curr_node = i
                        min_dist = d
                    end
                end
            end
            if curr_node ==0
                @debug println("cannot find solution")
                break
            end
            # this node position
            tnpos = node2pos(width, curr_node)
            @debug println("looking at node $(curr_node) at $(tnpos)")
            for n in get_neighbours(elevation, curr_node)
                # neighbour node position
                nnpos = node2pos(width, n)
                if visited[n] == 0
                    @debug println(" looking at neighbour $(n) at  $(nnpos)")
                    diff = elevation[nnpos[1],nnpos[2]] - elevation[tnpos[1],tnpos[2]]
                    # if the difference in elevation is at most 1 then we can make a single step
                    if diff <=1
                        @debug println("  potential step")
                        distances[n] = min(distances[n], distances[curr_node]+1)
                    end
                end
            end
            visited[curr_node] = 1
        end
        @debug println("shortest distances is $(distances[goal_node])")
        if distances[goal_node] < best_dist
            best_dist = distances[goal_node]
            best_start = start
        end
    end
    println("best start is $(best_start) with distance $(best_dist)")
    return best_dist
end

function main()
    with_logger(ConsoleLogger(stderr, Logging.Debug)) do
        @assert part1(readlines(open("test.txt"))) == 31
    end
    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 1 is $(part1(data))")
    end

    with_logger(ConsoleLogger(stderr, Logging.Debug)) do
        @assert part2(readlines(open("test.txt"))) == 29
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