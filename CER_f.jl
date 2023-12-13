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

function find_rankn(mat)
    num_rows, num_cols = size(mat)
    rank = min(num_rows, num_cols)
    global b = 0
    global r = 0
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
            global r += 1
        end
        global b = 0
    end
    return r
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

p_values1 = Float64[]
rate_values1 = Float64[]

matG1=[1 1 1 1 1 1 1]

q=(1-0.27)/7
for p in 0.27:q:1

    k = size(matG1, 1)
    global e = 0
    global n = 1
    while true
        matM = genM(matG1)
        matC = genC(matM, matG1)
        matC1 = transC(matC, p)
        matĒ = posĒ(matC1)
        matGĒ = createGĒ(matĒ, matG1)
        if find_rank(matGĒ) != k
            global e += 1
        end
        global rate = e / n
        global n+=1
        if e>=200 && n>=10000
            break
        end
    end
        push!(p_values1, p)
        push!(rate_values1, rate)
end

p1 = plot(p_values1, rate_values1, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", yaxis=:log10,markersize=6, markercolor=:red, markeralpha=0.8)
p1 = scatter!(p_values1, rate_values1, yaxis=:log10,markersize=6, markercolor=:red, markeralpha=0.8)


p_values2 = Float64[]
rate_values2 = Float64[]
matG2=[1 0 0 1;
       0 1 0 1;
       0 0 1 1]

q=(1-0.0045)/7
for p in 0.0045:q:1

    k = size(matG2, 1)
    global e = 0
    global n = 1
    while true
        matM = genM(matG2)
        matC = genC(matM, matG2)
        matC1 = transC(matC, p)
        matĒ = posĒ(matC1)
        matGĒ = createGĒ(matĒ, matG2)
        if find_rank(matGĒ) != k
            global e += 1
        end
        global rate = e / n
        global n+=1
        if e>=200 && n>=10000
            break
        end
    end
        push!(p_values2, p)
        push!(rate_values2, rate)
end

p2 = plot(p_values2, rate_values2, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", yaxis=:log10,markersize=6, markercolor=:red, markeralpha=0.8)
p2 = scatter!(p_values2, rate_values2, yaxis=:log10,markersize=6, markercolor=:red, markeralpha=0.8)

p_values3 = Float64[]
rate_values3 = Float64[]
matG3 = [1 0 0 1 1 0 1;
         0 1 0 1 0 1 1;
         0 0 1 0 1 1 1]

q=(1-0.064)/7
for p in 0.064:q:1

    k = size(matG3, 1)
    global e = 0
    global n = 1
    while true
        matM = genM(matG3)
        matC = genC(matM, matG3)
        matC1 = transC(matC, p)
        matĒ = posĒ(matC1)
        matGĒ = createGĒ(matĒ, matG3)
        if find_rank(matGĒ) != k
            global e += 1
        end
        global rate = e / n
        global n+=1
        if e>=200 && n>=10000
            break
        end
    end
        push!(p_values3, p)
        push!(rate_values3, rate)
end

p3 = plot(p_values3, rate_values3, xlabel="p", ylabel="Rate", label="Codeword Erasure Rate vs. p", yaxis=:log10,markersize=6, markercolor=:red, markeralpha=0.8)
p3 = scatter!(p_values3, rate_values3, yaxis=:log10,markersize=6, markercolor=:red, markeralpha=0.8)

plot(p1,p2,p3, layout=(2, 2), legend=false)
