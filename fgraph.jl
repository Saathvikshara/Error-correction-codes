using Plots

x=[0.6966255144,0.7023398001142857,0.7080540858285714,0.7137683715428571,0.7194826572571429, 0.7251969429714286, 0.7309112286857143, 0.7366255144]
y=[0.0000701166,0.0003460926143,0.0016000800040002,0.0090716661626,0.040104010401040106, 0.11791179117911792, 0.29322932293229326, 0.5213521352135213]
rate=576/2187
z = Float64[]
for i in 1:8
    push!(z, x[i]-(1-rate))
end


#p1 = plot(x, y, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p",yaxis=:log10)
#p2 = plot(z, y, xlabel="p2", ylabel="Rate", label="Codeword Erasure Rate vs. p",markersize=6, markercolor=:red, markeralpha=0.8)
#p2 = scatter!(z, y,markersize=6, markercolor=:red, markeralpha=0.8)
p3 = plot(z, y, xlabel="p-(1-R)",yaxis=:log10, ylabel="CER", label="RMC",markersize=6, markercolor=:red, markeralpha=0.8)
p3 = scatter!(z, y,markersize=6,yaxis=:log10, markercolor=:red, markeralpha=0.8)
p4 = plot(z, y, xlabel="p3",yscale=:log10, ylabel="Rate", label="Codeword Erasure Rate vs. p",markersize=6, markercolor=:red, markeralpha=0.8)
p4 = scatter!(z, y,markersize=6,yscale=:log10, markercolor=:red, markeralpha=0.8)
plot(p3,p4, layout=(1, 2), legend=false)



