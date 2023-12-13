using Plots

x=[0.6855859375,0.692252604167,0.6989192708333334,0.7055859375,0.7122526041666667,0.7189192708333333,0.72558593750000000000000000000002]
y=[0.00005562678,0.0004512,0.004510193036261952,0.026502650265026503,0.09890989098909891,0.2654265426542654,0.5186721991701]

rate=562/2048
z = Float64[]
for i in 1:7
    push!(z, x[i]-(1-rate))
end


#p1 = plot(x, y, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p",yaxis=:log10)
p2 = plot(z, y, xlabel="p2", ylabel="Rate", label="Codeword Erasure Rate vs. p",markersize=6, markercolor=:red, markeralpha=0.8)
p2 = scatter!(z, y,markersize=6, markercolor=:red, markeralpha=0.8)
p3 = plot(z, y, xlabel="p-(1-R)",yaxis=:log10, ylabel="CER", label="RMC",markersize=6, markercolor=:red, markeralpha=0.8)
p3 = scatter!(z, y,markersize=6,yaxis=:log10, markercolor=:red, markeralpha=0.8)
p4 = plot(z, y, xlabel="p3",yscale=:log10, ylabel="Rate", label="Codeword Erasure Rate vs. p",markersize=6, markercolor=:red, markeralpha=0.8)
p4 = scatter!(z, y,markersize=6,yscale=:log10, markercolor=:red, markeralpha=0.8)
plot(p2,p3, layout=(1, 2), legend=false)


