using RICoverAlg

# Queueing problems
m = 2;  n = 40 ; lmd = 1.0
g = ones(n); g /=sum(g)
U = zeros(m, n)
for i in (1:n)
   U[2,i] = 28 - i
end
# shiftterm = (((maximum(U)+minimum(U))/2))   ## reduce extremes of U for numerical stability
Z = exp.((U.-0)/lmd)

@test convertInputsToFloats(U,g,1) == (U,g,1.)
@test convertInputsToFloats([2 1],g, 1//10) == ([2. 1.],g,.1)
#@test convertInputsToFloats([2; 1],1, 1//10) == ([2.; 1.],1.,.1) # how to convert a number to Array if necessary
#@test cancelZeroStates([4 5; 6 7], [0 1]) == ([5; 7], [1], [2]) # why is this test not working?
@test checkForTriviality([2. 1.],[.1; 0.9],1) == (ones(1), log(2.)*.1+log(1.)*.9, 0, "Trivial: only one action is possible")
@test checkForTriviality([2. ; 1.],[1],2) == ([1. ; 0.], log(2.0), 0, "Trivial: only one state is possible")

@test risolve(U, g, 10)[1] == [0.0, 1.0]
@test risolve(reverse(U,dims=1), g, 10)[3] == "Found boundary solution (two alternatives only); Number of iterations: 0; Resulting payoff 7.500000000000002 is 1.0 optimal (maximal payoff <= 7.500000000000002)"

# Matejka & McKay 2015, RBT
U = [0 1 0 1;
    0 0 1 1;
    1/2 1/2 1/2 1/2]
lmd = 0.4
g = [1+1; 1-1; 1-1; 1+1]./4
@test convertInputsToFloats(U,g,lmd) == (U./1.,g,lmd)
@test cancelZeroStates(U,g ) == (U[:,[1,4]],[.5, .5 ],[1, 4])
@test transform_utilities(U[:,[1,4]],lmd) == ( exp.((U[:,[1,4]].-.0)/lmd)   ,  .0   )
