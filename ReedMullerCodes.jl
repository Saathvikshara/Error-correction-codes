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
    return rank
end

function find_rankn(mat)
    num_rows, num_cols = size(mat)
    rank = min(num_rows, num_cols)
    global b = 0
    global ra = 0
    for row in 1:rank
        if mat[row, row] == 0
            non_zero_row = findfirst(x -> x != 0, mat[row:end, row])
            if non_zero_row === nothing
                rank -= 1
                for j in 1:num_rows
                    mat[j,row]=mat[j,num_cols]
                end
            else
                swap_rows!(mat, row, non_zero_row + row - 1)
                continue
            end
            row -=1
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
            global ra += 1
        end
        global b = 0
    end
    return ra
end

function genRMC(m)
    global matA = [1 0;
                   1 1]

    for i in 2:m
        matB = zeros(Int, 2^i, 2^i)
        matB[1:2^(i-1), 1:2^(i-1)] = matA[:]
        matB[(2^(i-1))+1:2^i, 1:2^(i-1)] = matA[:]
        matB[(2^(i-1))+1:2^i, (2^(i-1))+1:2^i] = matA[:]
        global matA = matB
    end
    return matA
end

function genG(matA, m, r)
    row, col = size(matA)
    vecG = Vector{Vector{Int}}()
    global f = 0
    for i in 1:row
        for j in 1:col
            if matA[i, j] == 1
                global f += 1
            end
        end
        if f >= 2^(m - r)
            push!(vecG, matA[i, :])
        end
        global f = 0
    end
    matG = hcat(vecG...)
    return matG'
end

function mat_disp(mat)
    row,col=size(mat)
    for i in 1:row
        for j in 1:col
            print(mat[i,j]," ")
        end
        println()
    end
end

p_values = Float64[]
rate_values = Float64[]

mat1 = genRMC(11)
matG = genG(mat1,11,4)

#mat_disp(mat1)
#println()
#print(matG)
for p in 0.1:0.1:1
    #matG=[1 1 1 1 1 1 1]

    #matG=[1 0 0 1;
    #      0 1 0 1;
    #      0 0 1 1]

    #matG = [1 0 0 1 1 0 1;
    #        0 1 0 1 0 1 1;
    #        0 0 1 0 1 1 1]

    k = size(matG, 1)
    #r=size(matG,2)
    #println(k," ",r)
    #p = 0.1
    global e = 0
    n = 100
    for i in 1:n
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
        #println("rank of matGĒ=",find_rankn(matGĒ))
        rank = find_rankn(matGĒ)
        rank1 = find_rankn(matG)
        #println("rank of matG=",rank1)
        if rank != k
            global e += 1
            #print("The message cannot be decoded")
            #else
            #print("The message can be decoded")
        end
    print(i)
    end
    println()
    rate = e / n
    println(rate," ",p)
    #lrate = log10(rate)
    #print("The Codeword Erasure Rate is = ",rate)
    #print(rate)
    #if e >= 200
        push!(p_values, p)
        push!(rate_values, rate)
    #end
end
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

p1 = plot(p_values, rate_values, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p")
p2 = plot(p_values, rate_values, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", yaxis=:log10)
#p3 = plot(p_val, rate_val, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", markersize=6, markercolor=:red, markeralpha=0.8)
#p3 = scatter!(p_val, rate_val, markersize=6, markercolor=:red, markeralpha=0.8)
#p4 = plot(p_val, rate_val, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", yaxis=:log10, markersize=6, markercolor=:red, markeralpha=0.8)
#p4 = scatter!(p_val, rate_val, yaxis=:log10, markersize=6, markercolor=:red, markeralpha=0.8)
plot(p1, p2, layout=(2, 2), legend=false)