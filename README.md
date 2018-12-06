# RICoverAlg
This is a Julia repository to compute solutions for a discrecte rational inattention problem (Sims 2003, https://doi.org/10.1016/S0304-3932(03)00029-1) using the algorithm suggested by Thomas Cover (1984, https://doi.org/10.1109/TIT.1984.1056869).

## Installing this Package
Since this package is not registered, you must install it by cloning. To add this package, type "]" in the REPL to enter the pkg manager and execute:
    clone("https://github.com/frankhuettner/RICoverAlg.jl")


## Usage
    using RICoverAlg
    risolve(UtilTable, g, λ)
where 'UtilTable' is a payoff matrix: the rows correspond to the actions, the columns to the states, and an entry is the payoff the decision maker gets in the particular combination of state and action;
'g' is vector of prior probabilities over the states;
'λ' is the unit cost of learning.

## Example
The code below creates Figure 1 of Matejka and McKay (2015, http://dx.doi.org/10.1257/aer.20130047):

    using RICoverAlg
    using PyPlot
    UtilTable = [0 1 0 1;
        0 0 1 1;
        1/2 1/2 1/2 1/2]
    λ = 0.4
    ρ = 0
    res = []
    for ρ=-1:0.1:1
        g = [1+ρ; 1-ρ; 1-ρ; 1+ρ]./4
        result = risolve(UtilTable, g, λ)
        push!(res,result[1][1])
    end

    fig, ax = subplots()
    ax[:plot](collect(-1:.1:1),collect(0.5:-0.0125:0.25), color="black", marker="o",   linewidth=2, label=L"$\lambda = 0$", alpha=0.6)
    ax[:plot](collect(-1:.1:1),res, color="purple", marker="s",  linewidth=2, label=L"$\lambda = 0.4$", alpha=0.6)
    ax[:legend](loc="upper right")
    ax[:set_title](L"Unconditional Probability of Selecting a Bus for Various Values of $\lambda$ and $\rho$ (The probability is the same for both the red and blue buses)")
    ax[:set_xlabel](L"$\rho$")
    ax[:set_ylabel](L"Probability")
    # savefig("plot") #uncomment to safe the figure
![alt text](doc/img/MM_RBT.png "Figure 1 of Majetka and McKay (2015) -- computation done with the package RICoverAlg")
