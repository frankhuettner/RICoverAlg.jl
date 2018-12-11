using RICoverAlg

# Queueing problems
m = 2;  n = 40 ; lmd = 1.0
g = ones(n); g /=sum(g)
U = zeros(m, n)
for i in (1:n)
   U[2,i] = 28 - i
end
Z = exp.((U.-0)/lmd)

@test convertInputsToFloats(U,g,1, [.5,1//2]) == (U,g,1.,[.5,.5])
@test convertInputsToFloats([2 1],g, 1//10, [.5,1//2]) == ([2. 1.],g,.1, [.5,.5])
#@test convertInputsToFloats([2; 1],1, 1//10) == ([2.; 1.],1.,.1) # how to convert a number to Array if necessary
#@test cancelZeroStates([4 5; 6 7], [0 1]) == ([5; 7], [1], [2]) # why is this test not working?
@test checkForTriviality([2. 1.],[.1; 0.9],1) == (ones(1), log(2.)*.1+log(1.)*.9, 0, "Trivial: only one action is possible")
@test checkForTriviality([2. ; 1.],[1],2) == ([1. ; 0.], log(2.0), 0, "Trivial: only one state is possible")

# Matejka & McKay 2015, RBT
U = [0 1 0 1;
    0 0 1 1;
    1/2 1/2 1/2 1/2]
lmd = 0.4
g = [1+1; 1-1; 1-1; 1+1]./4
@test convertInputsToFloats(U,g,lmd,[.25,1//4,.25,1//4]) == (U./1.,g,lmd,[.25,.25,.25,.25])
@test cancelZeroStates(U,g ) == (U[:,[1,4]],[.5, .5 ],[1, 4])
@test transform_utilities(U[:,[1,4]],lmd) == ( exp.(U[:,[1,4]]/lmd)   )
