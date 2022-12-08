#=
--- Day 8: Treetop Tree House ---
The expedition comes across a peculiar patch of tall trees all planted carefully in a grid. The Elves explain that a previous expedition planted these trees as a reforestation effort. Now, they're curious if this would be a good location for a tree house.

First, determine whether there is enough tree cover here to keep a tree house hidden. To do this, you need to count the number of trees that are visible from outside the grid when looking directly along a row or column.

The Elves have already launched a quadcopter to generate a map with the height of each tree (your puzzle input). For example:

30373
25512
65332
33549
35390
Each tree is represented as a single digit whose value is its height, where 0 is the shortest and 9 is the tallest.

A tree is visible if all of the other trees between it and an edge of the grid are shorter than it. Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree.

All of the trees around the edge of the grid are visible - since they are already on the edge, there are no trees to block the view. In this example, that only leaves the interior nine trees to consider:

The top-left 5 is visible from the left and top. (It isn't visible from the right or bottom since other trees of height 5 are in the way.)
The top-middle 5 is visible from the top and right.
The top-right 1 is not visible from any direction; for it to be visible, there would need to only be trees of height 0 between it and an edge.
The left-middle 5 is visible, but only from the right.
The center 3 is not visible from any direction; for it to be visible, there would need to be only trees of at most height 2 between it and an edge.
The right-middle 3 is visible from the right.
In the bottom row, the middle 5 is visible, but the 3 and 4 are not.
With 16 trees visible on the edge and another 5 visible in the interior, a total of 21 trees are visible in this arrangement.

Consider your map; how many trees are visible from outside the grid?
=#


function is_visible(grid, i, j)
    # edges are always visible
    if (j == 1) | (i == 1)
        return true
    end
    if (j == size(grid)[2]) | (i == size(grid)[1])
        return true
    end
    height = grid[i, j]

    #left
    vis = true
    for col in j-1:-1:1
        # println("testing $(i),$(col):$(grid[i, col])")
        if grid[i, col] >= height
            vis = false
            break
        end
    end
    # println("$(height) visible from the left: $(vis)")
    vis && return true

    #right
    vis = true
    for col in j+1:size(grid)[2]
        # println("testing $(i),$(col):$(grid[i, col])")
        if grid[i, col] >= height
            vis = false
            break
        end
    end
    # println("$(height) visible from the right: $(vis)")
    vis && return true

    #up
    vis = true
    for row in i-1:-1:1
        # println("testing $(row),$(j)")
        if grid[row, j] >= height
            vis = false
            break
        end
    end
    # println("$(height) visible from the top: $(vis)")
    vis && return true

    #down
    vis = true
    for row in i+1:size(grid)[1]
        # println("testing $(row),$(j)")
        if grid[row, j] >= height
            vis = false
            break
        end
    end
    # println("$(height) visible from the bottom: $(vis)")
    vis && return true
    return false
end


function part1(data)
    # load the data into a grid
    height = length(data)
    width = length(data[1])
    grid = Array{Int}(undef, height, width)
    for (i, line) in enumerate(data)
        for (j, char) in enumerate(strip(line))
            grid[i, j] = parse(Int, char)
        end
    end
    visible = similar(grid)

    for i in 1:width
        for j in 1:height
            # println(i, j, grid[i, j])
            visible[i, j] = is_visible(grid, i, j)
        end
    end
    # println(visible)
    # println(sum(visible))
    return sum(visible)
end

function part2(data)
    return false
end

function main()
    @assert part1(readlines(open("test.txt"))) == 21

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