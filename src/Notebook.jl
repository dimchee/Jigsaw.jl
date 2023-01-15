### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ 567dc94c-7bf3-11ed-0746-f3aa55065bb2
begin
    import Pkg
    Pkg.activate(Base.current_project())
    Pkg.instantiate()

	using Transducers, Images, Jigsaw
end

# ╔═╡ dce9106c-82c3-445b-bbaf-aec32b691093
vanGogh = load("../res/VanGogh.jpg")

# ╔═╡ 5bcbe107-86a0-426a-9401-048e8dd07ad0
puzzle = puzzlify(parts(100, 50)(vanGogh), (x, y) -> x > 0 || (x+0.4)^2 + y^2 < 0.6^2, 50)

# ╔═╡ 6d4f0b03-c9cc-48aa-8004-44c47787ad46
begin
	n, m = puzzle |> size
	reduce(vcat, [
    	reduce(hcat, [puzzle[i, k] for k in 1:m])
    	for i in 1:n
	])
end

# ╔═╡ Cell order:
# ╠═567dc94c-7bf3-11ed-0746-f3aa55065bb2
# ╠═dce9106c-82c3-445b-bbaf-aec32b691093
# ╠═5bcbe107-86a0-426a-9401-048e8dd07ad0
# ╠═6d4f0b03-c9cc-48aa-8004-44c47787ad46
