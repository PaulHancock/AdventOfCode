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
=#

function adjmatrix(graph)
    height, width = size(graph)
    mat = zeros(Int, (length(graph),length(graph))) .+ Inf
    for row in 1:height
        for col in 1:width
            for i in max(row-1,1):min(row+1, height) 
                for j in max(col-1,1):min(col+1,width)
                    if graph[row,col] <= graph[i,j]+1 # can step down any dist, but only up max of 1 height
                        mindex = (row-1)*width + col
                        mat[mindex, (i-1)*width + j] = graph[i,j] - graph[row,col]
                    end
                end
            end
        end
    end
    return mat
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
        elseif 'E' in line
            index = findall('E',line)
            line = replace(line, 'E'=>'z')
            goal = [i,index[1]]
        end
        elevation[i, begin:end] = [convert(Int,i)-offset for i in line]
    end
    println("Starting at $(start), and working towards $(goal)")
    println(elevation)
    adjm = adjmatrix(elevation)
    for l in 1:size(adjm)[1]
        println(adjm[l, begin:end])
    end

    visitd = [false for i in 1:length(elevation)]
    distances = [ Inf for i in 1:length(elevation)]
    distances[1] = 0
    for node in 2:length(elevation)
        row = div(node, width) +1
        col = mod(node, width) +1
        for i in max(row-1,1):min(row+1, height) 
            for j in max(col-1,1):min(col+1,width)
                if (i!=row) && (j!= col) && (graph[row,col] <= graph[i,j]+1) # can step down any dist, but only up max of 1 height
                    distances[node] = graph[i,j] - graph[row,col]
                end
            end
        end

    end
    return false
end

function part2(data)
    return false
end

function main()
    @assert part1(readlines(open("test.txt"))) == 31

    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 1 is $(part1(data))")
    end

    @assert part2(readlines(open("test.txt"))) == true

    open("input.txt") do f
        # read till end of file
        data = readlines(f)
        println("Part 2 is $(part2(data))")
    end

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end