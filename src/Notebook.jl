### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ 567dc94c-7bf3-11ed-0746-f3aa55065bb2
begin
    import Pkg
    Pkg.activate(Base.current_project())
    Pkg.instantiate()

    using Transducers, Images
	using Jigsaw
end

# ╔═╡ dce9106c-82c3-445b-bbaf-aec32b691093
vanGogh = load("../res/VanGogh.jpg")

# ╔═╡ 558bc79b-16c1-4983-a8a5-938c94419b73
ps = parts(vanGogh)

# ╔═╡ 5bcbe107-86a0-426a-9401-048e8dd07ad0
puzzlify(ps, (x, y) -> x > 0 || (x+0.4)^2 + y^2 < 0.6^2)

# ╔═╡ Cell order:
# ╠═567dc94c-7bf3-11ed-0746-f3aa55065bb2
# ╠═dce9106c-82c3-445b-bbaf-aec32b691093
# ╠═558bc79b-16c1-4983-a8a5-938c94419b73
# ╠═5bcbe107-86a0-426a-9401-048e8dd07ad0
