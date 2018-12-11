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

@test t1 <= 0.3


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

# JKMS Section V.1.

##-------
using Distributions
using Plots
plotly() # Choose a backend

function jkms_setup()
   λ = 0.5
   Y = collect(-3:0.001:3)
   X = collect(-3:0.001:3)
   Truncated(Normal(),-3,3)
   g_of_Y = pdf.(Truncated(Normal(),-3,3),Y)

   u(x,y) = -0.5*(x-y)^2
   utilTable = hcat([[u(x,y) for y in Y] for x in X]...)' ;
   p_guess = ones(length(X))/length(X)
   return utilTable, g_of_Y, λ,p_guess
end

utilTable, g_of_Y, λ,p_guess = jkms_setup()
results = []

function jkms_run(utilTable, g_of_Y, λ,p_guess;iterations=100,aTol4SetProbsToZero = 0.0001,aTol4SetMinProbsToZero=0.0001)
   result =  @time risolve(utilTable, g_of_Y, λ,
                           iterationBtwSetting2Zero  = 10,
                           aTol4SetProbsToZero = aTol4SetProbsToZero,
                           aTol4SetMinProbsToZero = aTol4SetMinProbsToZero,
                           aTol4Stopping = 0.0,
                           maxIterations = iterations,
                           p_guess = p_guess)
   push!(results,result)
   p = result[1]
   idxplus = findall(a->(a>0.0), p)
   println("Choosen actions: ",length(idxplus)," p_min: ", minimum(p[idxplus])," p_max: ", maximum(p[idxplus]), " payoff: ", result[2])
   return results
end
##--------
function jkms_sim()
   res= jkms_run(utilTable, g_of_Y, λ,p_guess,iterations=100,aTol4SetProbsToZero= 0.1/6000)


   for i in 1:10
      res2 = jkms_run(utilTable, g_of_Y, λ,res[1],iterations=1000,aTol4SetProbsToZero= 0.0001,aTol4SetMinProbsToZero=0.00015)
      # aTol4SetProbsToZero= 0.0005 ,aTol4SetMinProbsToZero=0.001 boils down to 4 variables but is rather bad
      # aTol4SetProbsToZero= 0.0001,aTol4SetMinProbsToZero=0.00015 i.e. cautious cancelling of low variables leads to better outcome
      res = res2
   end
   return res
end
##--------
function jkms_sim_continue(loops,p_guess)
   for i in 1:loops
      p_guess_2 = jkms_run(utilTable, g_of_Y, λ,p_guess,iterations=1000,aTol4SetProbsToZero= 0.0001,aTol4SetMinProbsToZero=0.00015)[1]
      # aTol4SetProbsToZero= 0.0005 ,aTol4SetMinProbsToZero=0.001 boils down to 4 variables but is rather bad
      # aTol4SetProbsToZero= 0.0001,aTol4SetMinProbsToZero=0.00015 i.e. cautious cancelling of low variables leads to better outcome
      p_guess = p_guess_2
   end
   return p_guess
end
##--------

res_opt = jkms_sim()

res_opt[ 1]

idxplus = findall(a->(a>0.0), res_opt[1])

plot(collect(-3:0.001:3),res_opt2)
length(idxplus)

res_opt[1][idxplus]

p_g = zeros(6001)
p_g[3001+174] = .25
p_g[3001+1088] = .25
p_g[3001-174] = .25
p_g[3001-1088] = .25
##--------
res_opt2 = jkms_sim_continue(28,res_opt[1])
@save "res_opt2.jld2" res_opt2
#### ## for developing stuff
# cd("C://Users//Frank_sPro//Nextcloud//my_JuliaDev//RICoverAlg")
cd("C://Users//info//Nextcloud//my_JuliaDev//RICoverAlg")
using Pkg
Pkg.activate(".")
using Revise
using RICoverAlg
####
