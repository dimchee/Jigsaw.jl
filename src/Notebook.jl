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
vanGogh = load("../res/kauernder_junge.jpg")

# ╔═╡ 07d54a7a-5edd-4d33-8d09-69d4ba8abbd4
part = partitioner(100, 50)

# ╔═╡ 5bcbe107-86a0-426a-9401-048e8dd07ad0
puzzle = puzzlify()(part(vanGogh))

# ╔═╡ 43e29f5f-daa1-4a95-af75-2a33080d9177
size(puzzle)

# ╔═╡ Cell order:
# ╠═567dc94c-7bf3-11ed-0746-f3aa55065bb2
# ╠═dce9106c-82c3-445b-bbaf-aec32b691093
# ╠═07d54a7a-5edd-4d33-8d09-69d4ba8abbd4
# ╠═5bcbe107-86a0-426a-9401-048e8dd07ad0
# ╠═43e29f5f-daa1-4a95-af75-2a33080d9177
