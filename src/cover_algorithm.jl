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
                                  aTol4SetProbsToZero::Float64=10e-7)
    notToZero = findall(a->(a> aTol4SetProbsToZero), p)
    if length(notToZero)<length(p)   ## we'll set props close to zero to equal zero
        p=p[notToZero]
        p/=sum(p)
        Z=Z[notToZero,:]
    end
    return Z, p, notToZero
end

function cancel_min_alternatives(Z::Array{Float64,2},
                                  p::Array{Float64,1};
                                  aTol4SetProbsToZero::Float64=10e-7,
                                  aTol4SetMinProbsToZero::Float64=10e-7)
    p_min = findmin(p)[1]
    if p_min < aTol4SetMinProbsToZero
        notToZero = findall(a->(a>p_min+eps()), p)
        p=p[notToZero]
        p/=sum(p)
        Z=Z[notToZero,:]
        return Z, p, notToZero
    else return Z, p, collect(range(1,length(p)))
end
end

function run_cover_algorithm(Z::Array{Float64,2},
                         g::Array{Float64,1};
                         iterationBtwSetting2Zero::Int  = 10,
                         aTol4SetProbsToZero::Float64 = 10e-7,
                         aTol4SetMinProbsToZero::Float64 = 10e-7,
                         aTol4Stopping::Float64 = eps(),
                         maxIterations::Int = 9999,
                         p_guess = ones(size(Z)[1])/(size(Z)[1]))

    # initialize
    tryCancelMinProbs = (aTol4SetProbsToZero < aTol4SetMinProbsToZero)
    message = "Run Cover Algorithm"
    notToZeroLists = []
    localZ = copy(Z)

    ## canceling zeros in p_guess
    localZ, p, notToZero = cancel_zero_alternatives(Z, p_guess, aTol4SetProbsToZero)
    push!(notToZeroLists, notToZero)

    iterationsDone = 0

    for coverCall in 1:fld(maxIterations,iterationBtwSetting2Zero)

        p = do_cover_iterations(localZ, g, p, iterationBtwSetting2Zero)
        p/=sum(p) # shouldn't be necessary but for numerical reasons we have to
        iterationsDone += iterationBtwSetting2Zero

        localZ, p, notToZero = cancel_zero_alternatives(localZ, p, aTol4SetProbsToZero)
        push!(notToZeroLists, notToZero)

        ## check necessary conditions (cover alg doesn't improve anymore beyond precision)
        all(  isapprox.( compute_factor(localZ,g,p), ones(length(p)); atol = aTol4Stopping )  ) && break

        ## setting minimal probs to zero
        tryCancelMinProbs && begin
            tempZ, tempP, tempNotToZero = cancel_min_alternatives(localZ, p,
                                            aTol4SetProbsToZero=aTol4SetProbsToZero,
                                            aTol4SetMinProbsToZero=aTol4SetMinProbsToZero)
            if ((log.(p'*localZ))*g) < ((log.(tempP'*tempZ))*g)
                localZ, p= tempZ, tempP
                push!(notToZeroLists, tempNotToZero)
            end
        end

    end

    ### next, we put back the zeros. to this end, we infer the indices that survived
    m = size(Z)[1]
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
