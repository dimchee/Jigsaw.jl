module Jigsaw

using Images, FileIO, Transducers

const Ind = Tuple{Int64, Int64}

function seq(n::Int64, step::Int64, margin::Int64)
    local it = Iterators.repeated(step) |>
        Scan(+) |> TakeWhile(x -> x + step <= n) |>
        MapCat(x -> (x + margin, x - margin)) |> collect
    (0, it, n) |> Cat() |> Consecutive(2) |> Map(((a, b),) -> (a+1):b)
end

const Img = Matrix{ColorTypes.RGB{FixedPointNumbers.N0f8}}

condFlip(vertical :: Bool) = if vertical; (a, b) -> (a, b) else (a, b) -> (b, a) end


# Solve problem with corners + different image sizes
function sepImgs!(func, vertical::Bool, margin::Int64)
    flip = condFlip(vertical)
    function(imgs :: Tuple{Img, Img})
        img1, img2 = imgs
        n, m = flip(size(img1)...)
        # Solve corners
        img1[flip((n-margin+1):n, (m-margin+1):m)...] .= Gray(0.0)
        img2[flip(1:margin      , (m-margin+1):m)...] .= Gray(0.0)
       
        for i in 1:2margin
            for j in (margin+1):(n-margin)
                x = (i-1) / (2margin - 1) * 2 - 1.0 # in [-1, 1]
                y = (j-1) / (2margin - 1) * 2 - m / 2margin
                if func(x, y)
                    img1[flip(n-2margin+i, j)...] = Gray(0.0)
                else
                    img2[flip(i, j)...] = Gray(0.0)
                end
            end
        end
    end
end
function puzzlify!(grid :: Matrix{Matrix{T}}, lock, margin=15) where T
    foreach(eachrow(grid)) do row 
        row |> Consecutive(2, 1) .|> sepImgs!(lock, false, margin)
    end
    foreach(eachcol(grid)) do col 
        col |> Consecutive(2, 1) .|> sepImgs!(lock, true , margin)
    end
end
function puzzlify(grid :: Matrix{Matrix{T}}, lock, margin=15) where T
    ngrid = copy(grid)
    puzzlify!(ngrid, lock, margin)
    return ngrid
end

function parts(img :: Matrix{T}, step=100, margin=15) where T
    xs, ys = img |> size .|> l -> seq(l, step, margin) |> collect
    [ img[i, j] for i in xs, j in ys ]
end

function test_puz(lock, margin=15)
    A = parts(load("res/VanGogh.jpg"), 100, margin)
    puzzlify!(A, lock, margin)
    save("test.png", A[1, 1])
end

function to_parts()
    A = load("res/VanGogh.jpg") |> parts
    puzzlify!(A, (x, y) -> x > 0 || (x+0.4)^2 + y^2 < 0.6^2)
    for i in eachindex(A)
        save("res/parts/part-$i.png", A[i])
    end
end

export to_parts, seq, parts, puzzlify!, puzzlify, test_puz 

end # module Jigsaw
