module Jigsaw

using Images, FileIO, Transducers

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
const Img = Matrix{ColorTypes.RGB{FixedPointNumbers.N0f8}}

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

function sepImgs!(lock, dir :: Symbol, margin :: Int64)
    overlapInds = overlapIndsDict(margin)
    function(imgs :: Tuple{Img, Img})
        img1, img2 = imgs
        overlap = zip(
                      Iterators.product(overlapInds[(dir, :end  )](img1 |> size)...),
                      Iterators.product(overlapInds[(dir, :start)](img2 |> size)...),
                     ) |> collect
        for ((ind1, ind2), (x, y)) in zip(overlap, cordMatrix[dir](overlap))
            if lock(x, y) img1[ind1...] = Gray(0.0) else img2[ind2...] = Gray(0.0) end
        end
    end
end

const traverse = Dict(:horizontal => eachrow, :vertical => eachcol)
function puzzlify!(grid :: Matrix{Img}, lock, dir :: Symbol, margin :: Int64)
    foreach(grid |> traverse[dir]) do vec
        vec |> Consecutive(2, 1) .|> sepImgs!(lock, dir, margin)
    end
end
function puzzlify!(grid :: Matrix{Img}, lock, margin = 15)
    puzzlify!(grid, lock, :horizontal, margin)
    puzzlify!(grid, lock, :vertical,   margin)
end
function puzzlify(grid :: Matrix{Img}, lock, margin = 15)
    ngrid = deepcopy(grid)
    puzzlify!(ngrid, lock, margin)
    return ngrid
end

function parts(step=100, margin=15)
    function(img :: Img)
        xs, ys = img |> size .|> l -> seq(l, step, margin) |> collect
        [ img[i, j] for i in xs, j in ys ]
    end
end

# Doesn't look right when step=100, margin=100
function to_parts(step = 100, margin = 15)
    A = "res/VanGogh.jpg" |> load |> parts(step, margin)
    puzzlify!(A, (x, y) -> x > 0 || (x+0.4)^2 + y^2 < 0.6^2, margin)
    for i in findall(_ -> true, A)
        save("res/parts/part-$i.png", A[i])
    end
end

export to_parts, seq, parts, puzzlify!, puzzlify

end # module Jigsaw
