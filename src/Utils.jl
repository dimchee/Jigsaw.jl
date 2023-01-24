import FileIO

puzzlify(shape = defaultShape, margin = 50) = function(grid :: Matrix{Img{Pix}}) where Pix
    ngrid = deepcopy(grid)
    puzzlify!(ngrid, shape, margin)
    return ngrid
end

function makePuzzle(path :: String; step = 100, margin = 50, shape = defaultShape)
    path |> load .|> RGBA |> partitioner(step, margin) |> puzzlify(shape, margin)
end

partitioner(;step = 100, margin = 50) = partitioner(step, margin)
function defaultShape(type :: Symbol)
    if type == :bump
        return (x :: Real, y :: Real) -> x > 0 || (x + 0.4)^2 + y^2 < 0.6^2 ? :right : :left
    end
    if type == :dent
        return (x :: Real, y :: Real) -> x > 0 && (x - 0.4)^2 + y^2 >= 0.6^2 ? :right : :left
    end
    throw("Shape accepts only `:bump` or `:dent`")
end

function valid(shape)
    bumped = [shape(:bump)(x, y) for x in -1:0.01:1, y in -1:0.01:1]
    dented = [shape(:dent)(x, y) for x in -1:0.01:1, y in -1:0.01:1]

    ## Check if component is connected to it's mother tile
    if all(x -> x != :left , bumped[1  , :]) return println("When bump, component not connected to left ") end
    if all(x -> x != :left , dented[1  , :]) return println("When dent, component not connected to left ") end
    if all(x -> x != :right, bumped[end, :]) return println("When bump, component not connected to right") end
    if all(x -> x != :right, dented[end, :]) return println("When dent, component not connected to right") end

    ## Expand so components are connected if attached to same tile
    bumped[1  , :] .= :left
    dented[1  , :] .= :left
    bumped[end, :] .= :right
    dented[end, :] .= :right

    ## Check if there is at most 1 connected component of each type
    if map(x -> x == :left, bumped) |> label_components |> mat -> any(x -> x > 1, mat)
        return println("When bump, left subtile is not connected component")
    end
    if map(x -> x == :right, bumped) |> label_components |> mat -> any(x -> x > 1, mat)
        return println("When bump, right subtile is not connected component")
    end
    if map(x -> x == :left, dented) |> label_components |> mat -> any(x -> x > 1, mat)
        return println("When dent, left subtile is not connected component")
    end
    if map(x -> x == :right, dented) |> label_components |> mat -> any(x -> x > 1, mat)
        return println("When dent, right subtile is not connected component")
    end

    println("Tile shape approved :)")
    println("(this is just heuristic, doesn't mean function is fine, try visual check)")
    
end

# pluto() = Pluto.run(notebook="src/Notebook.jl", auto_reload_from_file=true)
toImage(puzzle :: Matrix{Img{Pix}}) where Pix = puzzle |> eachrow .|> foldxd(hcat) |> foldxd(vcat)
save(dir :: String) = function(puzzle :: Matrix{Img{Pix}}) where Pix
    findall(_ -> true, puzzle) .|> i -> FileIO.save("$dir/part-$(i |> Tuple).png", puzzle[i])
    return
end

makeSplashImg() = makePuzzle("res/kauernder_junge.jpg") |>  toImage |> x -> FileIO.save("res/puzzle.png", x)

export puzzlify, makePuzzle, partitioner, defaultShape, toImage, save, valid
# Doesn't look right when step=100, margin=100
