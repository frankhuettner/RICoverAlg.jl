using RICoverAlg

# Queueing problems
m = 2;  n = 40 ; lmd = 1.0
g = ones(n); g /=sum(g)
U = zeros(m, n)
for i in (1:n)
   U[2,i] = 28 - i
end
Z = exp.(U/lmd)

@test cancel_zero_alternatives(U,g) == (U,g,findall(a->(!isapprox(a,0; atol = 0)), g))
@test do_cover_iterations(Z,g,[.5,.5]) == [0.2901315939203102, 0.7098684060796899]
@test run_cover_algorithm(Z,g) == ([0.2901315939203102, 0.7098684060796899],8.880930086724845,10,"all fine")
@test cancel_zero_alternatives(Z,g) == (Z,g,collect(1:1:40))
@test cancel_zero_alternatives(Z,[0.,1.]) == (Z[[2],:],[1.],[2])


# Matejka & McKay 2015, RBT
U = [0 1 0 1;
    0 0 1 1;
    1/2 1/2 1/2 1/2]
lmd = 0.4
g = [1+1; 1+1]./4
Z,shiftterm=  exp.((U[:,[1,4]].-.5)/lmd)   ,  .5
m = size(Z)[1]
p = ones(m)./m
@test do_cover_iterations(Z,g,p) == [0.2522629174954305
 0.2522629174954305
 0.495474165009139]
