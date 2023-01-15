import FileIO

puzzlify(shape = defaultShape, margin = 50) = function(grid :: Matrix{Img})
    ngrid = deepcopy(grid)
    puzzlify!(ngrid, shape, margin)
    return ngrid
end

function makePuzzle(path :: String; step = 100, margin = 50, shape = defaultShape)
    path |> load |> partitioner(step, margin) |> puzzlify(shape, margin)
end


partitioner(;step = 100, margin = 50) = partitioner(step, margin)
defaultShape(x, y) = x > 0 || (x+0.4)^2 + y^2 < 0.6^2
pluto() = Pluto.run(notebook="src/Notebook.jl", auto_reload_from_file=true)
toImage(puzzle :: Matrix{Img}) = puzzle |> eachrow .|> foldxd(hcat) |> foldxd(vcat)
save(dir :: String) = function(puzzle :: Matrix{Img})
    findall(_ -> true, puzzle) .|> i -> FileIO.save("$dir/part-$(i |> Tuple).png", puzzle[i])
    return
end

makeSplashImg() = makePuzzle("res/VanGogh.jpg") |>  toImage |> x -> FileIO.save("res/VanGoghPuzzle.png", x)

export puzzlify, makePuzzle, partitioner, defaultShape, pluto, toImage, save
# Doesn't look right when step=100, margin=100
