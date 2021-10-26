using RICoverAlg

# Queueing problems
m = 2;  n = 40 ; lmd = 1.0
g = ones(n); g /=sum(g)
U = zeros(m, n)
for i in (1:n)
   U[2,i] = 28 - i
end
Z = exp.(U/lmd)

risolve(U, g, lmd)

t1 = @elapsed begin
waitProbs = []  ## will store the unconditional probability of waiting for varying parameter
for parameter in (0:0.01:50)
    for i in (1:n)
       U[2,i] = parameter - i
    end
    Z = exp.(U/lmd)

result = risolve(U, g, lmd)
push!(waitProbs,result[1][2])   ## push!(list,x) adds x to list - here the second entry (lining up probs) of the result
end
end

@test t1 <= 0.43


# using BenchmarkTools
# @btime begin
# waitProbs = []  ## will store the unconditional probability of waiting for varying parameter
# for parameter in (0:0.01:50)
#     for i in (1:n)
#        U[2,i] = parameter - i
#     end
#     Z = exp.(U/lmd)
#
# result = risolve(U, g, lmd)
# push!(waitProbs,result[1][2])   ## push!(list,x) adds x to list - here the second entry (lining up probs) of the result
# end
# end
### output: 96.626 ms (1165614 allocations: 174.65 MiB)
