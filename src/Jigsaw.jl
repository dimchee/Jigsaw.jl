module Jigsaw

using Images, Transducers, Pluto

const Ind = Tuple{Int64, Int64}

function seq(n::Int64, step::Int64, margin::Int64)
    local it = Iterators.repeated(step) |> Scan(+) |>
        TakeWhile(x -> x <= n) |> DropLast(1) |>
        MapCat(x -> (x + margin, x - margin)) |> collect
    (0, it, n - n % step) |> Cat() |> Consecutive(2) |> Map(((a, b),) -> (a+1):b)
end

function overlapIndsDict(k :: Int64)
    Dict(
         (:vertical, :start) => ((n, m),)-> (1:k, 1:m),
         (:horizontal, :start) => ((n, m),) -> (1:n, 1:k),
         (:vertical, :end) => ((n, m),) -> ((n-k+1):n, 1:m),
         (:horizontal, :end) => ((n, m),) -> (1:n, (m-k+1):m)
        )
end
const Img = Matrix{Pix} where Pix

# Could be const, maybe be parametric on step and margin (so edge pieces are centered)
cordMatrix = Dict(
    :vertical => function(mat :: Matrix{T}) where T
        n, m = size(mat) .|> x -> x-1
        sz = min(n, m)
        [((2i - n) / sz, (2j - m) / sz) for i in 0:n, j in 0:m]
    end,
    :horizontal => function(mat :: Matrix{T}) where T
        n, m = size(mat) .|> x -> x-1
        sz = min(n, m)
        [((2j - m) / sz, (2i - n) / sz) for i in 0:n, j in 0:m]
    end,
)

function separateImgs!(shape, dir :: Symbol, margin :: Int64)
    overlapInds = overlapIndsDict(margin)
    function(imgs :: Tuple{Img{Pix}, Img{Pix}}) where Pix
        img1, img2 = imgs
        overlap = zip(
                      Iterators.product(overlapInds[(dir, :end  )](img1 |> size)...),
                      Iterators.product(overlapInds[(dir, :start)](img2 |> size)...),
                     ) |> collect
        for ((ind1, ind2), (x, y)) in zip(overlap, cordMatrix[dir](overlap))
            if shape(x, y) img1[ind1...] = zero(Pix) else img2[ind2...] = zero(Pix) end
        end
    end
end

const traverse = Dict(:horizontal => eachrow, :vertical => eachcol)
function puzzlify!(grid :: Matrix{Img{Pix}}, shape, dir :: Symbol, margin :: Int64) where Pix
    foreach(grid |> traverse[dir]) do vec
        vec |> Consecutive(2, 1) .|> separateImgs!(shape, dir, margin)
    end
end
function puzzlify!(grid :: Matrix{Img{Pix}}, shape, margin) where Pix
    puzzlify!(grid, shape, :horizontal, margin)
    puzzlify!(grid, shape, :vertical,   margin)
end

function partitioner(step, margin)
    function(img :: Img{Pix}) where Pix
        xs, ys = img |> size .|> l -> seq(l, step, margin) |> collect
        [ img[i, j] for i in xs, j in ys ]
    end
end

include("Utils.jl")

end # module Jigsaw
