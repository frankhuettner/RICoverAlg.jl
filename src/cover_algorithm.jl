function compute_factor(Z::Array{Float64,2},
                        g::Array{Float64,1},
                        p::Array{Float64,1})::Array{Float64,1}
    return (Z ./(p'*Z))*g
end

function do_cover_iterations(Z::Array{Float64,2},
                             g::Array{Float64,1},
                             p::Array{Float64,1},
                             num_of_iter::Int64 = 10)::Array{Float64,1}
    for i in 1:num_of_iter   ## do num_of_iter iterations
        p = p.* compute_factor(Z,g,p)
    end
    return p
end

function cancel_zero_alternatives(Z::Array{Float64,2},
                                  p::Array{Float64,1},
                                  aTolSetChoiceProbToZero::Real=0)
    notToZero = findall(a->(!isapprox(a,0; atol = aTolSetChoiceProbToZero)), p)
    if length(notToZero)<length(p)   ## we'll set props close to zero to equal zero
        p=p[notToZero]
        p/=sum(p)
        Z=Z[notToZero,:]
    end
    return Z, p, notToZero
end

function run_cover_algorithm(Z::Array{Float64,2},
                         g::Array{Float64,1};
                         initialIterations::Int  = 10,
                         aTolSetChoiceProbToZero::Float64 = sqrt(eps()),
                         aTolerance4Stopping::Float64 = eps(),
                         maxIterations::Int = 9999)

    #initialize
    message = "Run Cover Algorithm"
    notToZeroLists = []
    localZ = copy(Z)
    m = size(Z)[1]
    p = ones(m)./m    ## initialize the uncondition probs column vector, i.e. arrays of dimension n x 1
    iterationsDone = 0

    for coverCall in 1:fld(maxIterations,initialIterations)
        p = do_cover_iterations(localZ, g, p, initialIterations)
        iterationsDone += initialIterations

        localZ, p, notToZero = cancel_zero_alternatives(localZ, p, aTolSetChoiceProbToZero)
        push!(notToZeroLists, notToZero)

        ## check necessary conditions (cover alg doesn't improve anymore beyond precision)
        all(  isapprox.( compute_factor(localZ,g,p), ones(length(p)); atol = aTolerance4Stopping )  ) && break
    end

    ### next, we put back the zeros. to this end, we infer the indices that survived
    idxs = collect(1:m)
    while length(notToZeroLists)>0
        idxs=idxs[notToZeroLists[1]]
        popfirst!(notToZeroLists)
    end
    p_withzeros = zeros(m)
    p_withzeros[idxs]=p
    return p_withzeros, ((log.(p'*localZ))*g)[1] , iterationsDone, message
    # optimal probs, value, number of iterations, message
end
