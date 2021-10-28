# Queueing problems
m = 2;  n = 40 ; lmd = 1.0
g = ones(n); g /=sum(g)
U = zeros(m, n)
for i in (1:n)
   U[2,i] = 28 - i
end

@test  all(risolve(U,g,1,
                  initialIterations = 10,
                  aTolSetChoiceProbToZero = 10e-6,
                  aTolerance4Stopping = 0.0,
                  maxIterations = 9999)[1:2] .≈ ([0.2901315939203102, 0.7098684060796899],8.880930086724845))


# Matejka and McKay 2015, RBT
UtilTable = [0 1 0 1;
    0 0 1 1;
    1/2 1/2 1/2 1/2]
λ = 0.4
ρs = -1:0.1:1
results = [risolve(UtilTable, [1+ρ; 1-ρ; 1-ρ; 1+ρ]./4, λ)[1][1] for ρ in ρs]

correct_results = [ 0.5
 0.5000000000000001
 0.5
 0.5
 0.5
 0.5
 0.5
 0.49803143236800007
 0.47259634434957937
 0.4481775023391477
 0.4248079737420439
 0.4025132814392701
 0.38131040477540723
 0.3612070466744384
 0.34220131237025564
 0.32428179482751757
 0.3074280331092877
 0.2916113993696781
 0.27679620629020485
 0.2629410102570515
 0.2500000009320786 ]
@test all((results .+10) .≈ (correct_results .+ 10))
