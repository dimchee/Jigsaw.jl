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
defaultShape(x, y) = x > 0 || (x+0.4)^2 + y^2 < 0.6^2
pluto() = Pluto.run(notebook="src/Notebook.jl", auto_reload_from_file=true)
toImage(puzzle :: Matrix{Img{Pix}}) where Pix = puzzle |> eachrow .|> foldxd(hcat) |> foldxd(vcat)
save(dir :: String) = function(puzzle :: Matrix{Img{Pix}}) where Pix
    findall(_ -> true, puzzle) .|> i -> FileIO.save("$dir/part-$(i |> Tuple).png", puzzle[i])
    return
end

makeSplashImg() = makePuzzle("res/kauernder_junge.jpg") |>  toImage |> x -> FileIO.save("res/puzzle.png", x)

export puzzlify, makePuzzle, partitioner, defaultShape, pluto, toImage, save
# Doesn't look right when step=100, margin=100
