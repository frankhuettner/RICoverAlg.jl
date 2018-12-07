function convertInputsToFloats(U, g, lmd)
    U = convert(Array{Float64}, U)
    g = convert(Array{Float64}, g)
    lmd = convert(Float64, lmd)
    return U,g,lmd
end

function cancelZeroStates(U,g)
    ## cancel states with prior zero
    nonzeroStates = findall(a->a!=0, g)
    U = U[:,nonzeroStates]
    g = g[nonzeroStates]
    return U,g,nonzeroStates
end

function transform_utilities(U, lmd)
    # shiftterm = (((maximum(U)+minimum(U))/2))   ## reduce extremes of U for numerical stability
    # Z = exp.((U.-shiftterm)/lmd)    ## transform utilities
    shiftterm = 0
    Z = exp.(U/lmd)    ## transform utilities
    return Z, shiftterm
end

function checkForTriviality(Z,g,m)
    ## interupt if there is no RI problem
    if m==1  ## since only one action possible
        return ones(m), (log.(Z)*g)[1], 0, "Trivial: only one action is possible"
    end
    if typeof(Z)==Vector{Float64}  ## since only one state possible
        best_solution = findmax(Z[:,1])
        p = zeros(m)
        p[best_solution[2]]=1
        return p, log(best_solution[1]), 0, "Trivial: only one state is possible"
    end
    return "not trivial"
end

function checkForBoundarySolution(Z,g)
    ## check whether you have boundary solutions in case of two alternatives
    if (Z[1,:]./Z[2,:])'*g<1
        return [0, 1.0], log.(Z[2,:])'*g, 0,  "Found boundary solution (two alternatives only)"
    elseif (Z[2,:]./Z[1,:])'*g<1
        return [1.0, 0], log.(Z[1,:])'*g, 0,  "Found boundary solution (two alternatives only)"
    end
    return "no boundary solution"
end

function preprocessinput(U, g, lmd)
    m = size(U)[1]
    solution = (ones(m)/m,0,0,"Run Cover Algorithm")

    U,g = convertInputsToFloats(U, g, lmd)
    U,g,nonzeroStates = cancelZeroStates(U,g)
    Z,shiftterm = transform_utilities(U,lmd)
    intermediateSolution = checkForTriviality(Z,g,m)
    if intermediateSolution != "not trivial"
          solution = intermediateSolution
    end
    if m == 2
        intermediateSolution = checkForBoundarySolution(Z,g)
        if intermediateSolution != "no boundary solution"
              solution = intermediateSolution
        end
    end
    return Z,g,shiftterm,solution
end
