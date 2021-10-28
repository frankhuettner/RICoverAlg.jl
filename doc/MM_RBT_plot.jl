### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 0b30d8f2-3788-11ec-0155-cd3fa7eec623
begin
	import Pkg
	Pkg.add(url = "https://github.com/frankhuettner/RICoverAlg.jl")
	using RICoverAlg
end

# ╔═╡ 2e419b18-204f-4604-ac62-006112717796
begin
	Pkg.add("Plots")
	using Plots
end

# ╔═╡ 5f1dbaf1-c88e-43d8-8039-2c5eeba35f23
md"To use the package, you have to add it from its github url:"

# ╔═╡ 8432015b-9df7-43cf-afb5-86e4ffac350e
UtilTable = [0   1   0   1;
    		 0   0   1   1;
    		1/2 1/2 1/2 1/2]

# ╔═╡ 69ad0d60-17e7-4c17-9f95-91bacf47cc80
λ = 0.4

# ╔═╡ edbb7ffd-7325-4389-9164-4eebcb446160
md"We will compute the result for different prior beliefs, g = [1+ρ; 1-ρ; 1-ρ; 1+ρ], where ρ iterates in 0.1 steps from -1 to 1."

# ╔═╡ 5ad0d918-9639-42c5-9f21-acbf4bb477cf
ρs = -1:0.1:1

# ╔═╡ b48b5d06-3b0e-47ea-99a6-671fab98743b
results = [risolve(UtilTable, [1+ρ; 1-ρ; 1-ρ; 1+ρ]./4, λ)[1][1] for ρ in ρs]

# ╔═╡ 477f0966-d094-483d-b9ef-14000282f6c0
begin
	plot(-1:.1:1, results, label="λ=0.4", c=:purple, marker=:square, alpha=0.6,
	    xlabel="ρ", ylabel="Unconditional Choice Probability")
	plot!(-1:.1:1, 0.5:-0.0125:0.25, label="λ=0", c=:black, marker=:o, alpha=0.6)
end

# ╔═╡ ba95ef6b-7aae-4c59-88d1-671400d4d7d3
savefig("img/MM_RBT.png") 	

# ╔═╡ Cell order:
# ╟─5f1dbaf1-c88e-43d8-8039-2c5eeba35f23
# ╠═0b30d8f2-3788-11ec-0155-cd3fa7eec623
# ╠═8432015b-9df7-43cf-afb5-86e4ffac350e
# ╠═69ad0d60-17e7-4c17-9f95-91bacf47cc80
# ╟─edbb7ffd-7325-4389-9164-4eebcb446160
# ╠═5ad0d918-9639-42c5-9f21-acbf4bb477cf
# ╠═b48b5d06-3b0e-47ea-99a6-671fab98743b
# ╠═2e419b18-204f-4604-ac62-006112717796
# ╠═477f0966-d094-483d-b9ef-14000282f6c0
# ╠═ba95ef6b-7aae-4c59-88d1-671400d4d7d3
