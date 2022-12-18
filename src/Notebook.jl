### A Pluto.jl notebook ###
# v0.19.18

using Markdown
using InteractiveUtils

# ╔═╡ 567dc94c-7bf3-11ed-0746-f3aa55065bb2
begin
    import Pkg
    # activate the shared project environment
    Pkg.activate(Base.current_project())
    # instantiate, i.e. make sure that all packages are downloaded
    Pkg.instantiate()

    using Transducers, Images
	using Revise
	using Jigsaw
end

# ╔═╡ c1d2876a-2516-4560-8411-b5f3dae76f03
# ╠═╡ disabled = true
#=╠═╡
img = testimage("lighthouse")
  ╠═╡ =#

# ╔═╡ dce9106c-82c3-445b-bbaf-aec32b691093
vanGogh = load("../res/VanGogh.jpg")

# ╔═╡ 558bc79b-16c1-4983-a8a5-938c94419b73
ps = parts(vanGogh)

# ╔═╡ 5bcbe107-86a0-426a-9401-048e8dd07ad0
puzzlify(ps, (x, y) -> x > 0 || (x+0.4)^2 + y^2 < 0.6^2)

# ╔═╡ Cell order:
# ╠═567dc94c-7bf3-11ed-0746-f3aa55065bb2
# ╠═c1d2876a-2516-4560-8411-b5f3dae76f03
# ╠═dce9106c-82c3-445b-bbaf-aec32b691093
# ╠═558bc79b-16c1-4983-a8a5-938c94419b73
# ╠═5bcbe107-86a0-426a-9401-048e8dd07ad0
