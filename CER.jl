using Plots
function genM(matG)
    k = size(matG, 1)
    mat = rand(0:1:1, 1, k)
    return mat
end

function genC(matM, matG)
    k, n = size(matG)
    mat = zeros(Int, 1, n)
    for j in 1:n
        for l in 1:k
            mat[1, j] ⊻= matM[1, l] * matG[l, j]
        end
    end
    return mat
end

function transC(matC, p)
    n = size(matC, 2)
    for i in 1:n
        if rand() < p
            matC[1, i] = rand(2:1:10)
        end
    end
    return matC
end

function posĒ(matC1)
    n = size(matC1, 2)
    matĒ = Int[]
    for i in 1:n
        if matC1[1, i] == 0 || matC1[1, i] == 1
            push!(matĒ, i)
        end
    end
    return matĒ
end

function createGĒ(matĒ, matG)
    c, k = size(matĒ, 1), size(matG, 1)
    matGĒ = zeros(Int, k, c)

    for i in 1:c
        d = matĒ[i]
        for j in 1:k
            matGĒ[j, i] = matG[j, d]
        end
    end
    return matGĒ
end

function swap_rows!(mat, row1, row2)
    mat[row1, :], mat[row2, :] = mat[row2, :], mat[row1, :]
end

function div(a, b)
    if b != 0
        return a
    end
end

function sub(a, b)
    if a == b
        return 0
    else
        return 1
    end
end

function find_rank(mat) 
    num_rows, num_cols = size(mat)
    rank = min(num_rows, num_cols)
    global b = 0
    global rab = 0
    for row in 1:rank
        if mat[row, row] == 0
             non_zero_row = findfirst(x -> x != 0, mat[row:end, row])
            if non_zero_row === nothing
                rank -= 1
            else
                swap_rows!(mat, row, non_zero_row + row - 1)
            end
        end
        if mat[row, row] != 0
             for next_row in row+1:num_rows
                 ratio = div.(mat[next_row, row], mat[row, row])
                 mat[next_row, :] = sub.(mat[next_row, :], ratio .* mat[row, :])
            end
        end
    end
    for i in 1:num_rows
        for j in 1:num_cols
            if mat[i, j] == 0
                global b += 1
            end

        end
        if b != num_cols
            global rab += 1
        end
        global b = 0
    end
    return rab
end




function genRMC(m)
    global matA = [1 0 0;
                   1 1 0;
                   1 0 1]

    for i in 2:m
        n=size(matA,1)
        matB = zeros(Int, 3^i, 3^i)
        matB[1:n, 1:n] = matA[:]
        matB[n+1:2*n, 1:n] = matA[:]
        matB[2*n+1:3*n, 1:n] = matA[:]
        matB[n+1:2*n,n+1:2*n] = matA[:]
        matB[2*n+1:3*n,2*n+1:3*n] = matA[:]
        global matA = matB
    end
    return matA
end

function genG(matA, r1)
    row, col = size(matA)
    vecG = Vector{Vector{Int}}()
    global f = 0
    for i in 1:row
        for j in 1:col
            if matA[i, j] == 1
                global f += 1
            end
        end
        if f >= 2^(r1+1)
            push!(vecG, matA[i, :])
        end
        global f = 0
    end
    matG = hcat(vecG...)
    return matG'
end

p_values = Float64[]
rate_values = Float64[]

mat1 = genRMC(7)
matG = genG(mat1,5)

#matG=[1 1 1 1 1 1 1]

#matG=[1 0 0 1;
#      0 1 0 1;
#      0 0 1 1]

#matG = [1 0 0 1 1 0 1;
#        0 1 0 1 0 1 1;
#        0 0 1 0 1 1 1]

q=(0.7366255144-0.7080540858285714)/5
for p in 0.7194826572571429:q:0.7366255144
    k = size(matG, 1)
    global e = 0
    global n = 1
    while true
        matM = genM(matG)
        #println("matM=",matM)
        matC = genC(matM, matG)
        #println("matC=",matC)
        matC1 = transC(matC, p)
        #println("matC1=",matC1)
        matĒ = posĒ(matC1)
        #println("matĒ=",matĒ)
        matGĒ = createGĒ(matĒ, matG)
        #println("matGĒ=",(matGĒ))
        #println("rank of matGĒ=",find_rank(matGĒ))

        if find_rank(matGĒ) != k
            global e += 1
            if e%10==0 && e!=0
                println(e," ",p," ",n)
            end
            #print("The message cannot be decoded")
            #else
            #print("The message can be decoded")
        end
        
        global rate = e / n
        #print(n)
        global n+=1
        #=if n%1000 ==0
            println()
            print(rate)
            println()
        end=#
        if e>=200 && n>=10000
            #println(1)
            break
        end
        #print(n," ",e," ")
        if n==20000
            #println(2)
            break
        end
    
    end  
    println()
    println(rate," ",p)
    println()
    #lrate = log10(rate)
    #print("The Codeword Erasure Rate is = ",rate)
    
        push!(p_values, p)
        push!(rate_values, rate)
    
end

println()
println()
println(p_values)
println(rate_values)
#=p_val = Float64[]
rate_val = Float64[]

min_rate = minimum(rate_values)
min_ind = argmin(rate_values)
max_rate = maximum(rate_values)
max_ind = argmax(rate_values)

slot1 = (p_values[max_ind] - p_values[min_ind]) / 7
slot = round(slot1, digits=4)
for s in p_values[min_ind]:slot:p_values[max_ind]
    push!(p_val, s)
    r = findfirst(x -> x == s, p_values)
    push!(rate_val, rate_values[r])
end=#

#p1 = plot(p_values, rate_values, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p")
#p2 = plot(p_values, rate_values, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", yaxis=:log10,markersize=6, markercolor=:red, markeralpha=0.8)
#p2 = scatter!(p_values, rate_values, yaxis=:log10,markersize=6, markercolor=:red, markeralpha=0.8)
#p3 = plot(p_val, rate_val, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", markersize=6, markercolor=:red, markeralpha=0.8)
#p3 = scatter!(p_val, rate_val, markersize=6, markercolor=:red, markeralpha=0.8)
#p4 = plot(p_val, rate_val, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", yaxis=:log10, markersize=6, markercolor=:red, markeralpha=0.8)
#p4 = scatter!(p_val, rate_val, yaxis=:log10, markersize=6, markercolor=:red, markeralpha=0.8)
#plot(p2, layout=(2, 2), legend=false)
#=1. 0.6966255144
2. 0.7023398001142857
3. 0.7080540858285714
4. 0.7137683715428571
5. 0.7194826572571429
6. 0.7251969429714286
7. 0.7309112286857143
8. 0.7366255144=#