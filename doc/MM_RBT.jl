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

# ╔═╡ 5f1dbaf1-c88e-43d8-8039-2c5eeba35f23
md"To use the package, you have to add it from its github url:"

# ╔═╡ 810d16ce-035f-4f60-a19b-e0bff9adbc88
md"First, we define a utility table.  The rows contain the actions, the columns the utility in for each state 

👉 number of rows = number of actions

👉 number of columns = number of states"

# ╔═╡ 8432015b-9df7-43cf-afb5-86e4ffac350e
UtilTable = [0   1   0   1;
    		 0   0   1   1;
    		1/2 1/2 1/2 1/2]

# ╔═╡ b85ce32d-6d90-4d32-8fd0-171d42d74912
md"Let's also define the cost of learning parameter."

# ╔═╡ 69ad0d60-17e7-4c17-9f95-91bacf47cc80
λ = 0.4

# ╔═╡ edbb7ffd-7325-4389-9164-4eebcb446160
md"Finally, we need a prior belief over the states of the world."

# ╔═╡ f85781f3-55c1-4575-a837-83ce075c9dd5
g = [0.45, 0.05, 0.05, 0.45]

# ╔═╡ ba5e447b-1e14-417d-ab4f-38f54a638d51
md"Calling the function `risolve(UtilTable, g, λ)` gives the solution."

# ╔═╡ d27bb77b-d681-4262-b67f-239972caf753
result = risolve(UtilTable, g, λ)

# ╔═╡ f5885dd3-cd81-4a6d-85dc-a5bce60c4bb2
result[1][1]

# ╔═╡ Cell order:
# ╟─5f1dbaf1-c88e-43d8-8039-2c5eeba35f23
# ╠═0b30d8f2-3788-11ec-0155-cd3fa7eec623
# ╟─810d16ce-035f-4f60-a19b-e0bff9adbc88
# ╠═8432015b-9df7-43cf-afb5-86e4ffac350e
# ╟─b85ce32d-6d90-4d32-8fd0-171d42d74912
# ╠═69ad0d60-17e7-4c17-9f95-91bacf47cc80
# ╟─edbb7ffd-7325-4389-9164-4eebcb446160
# ╠═f85781f3-55c1-4575-a837-83ce075c9dd5
# ╟─ba5e447b-1e14-417d-ab4f-38f54a638d51
# ╠═d27bb77b-d681-4262-b67f-239972caf753
# ╠═f5885dd3-cd81-4a6d-85dc-a5bce60c4bb2
