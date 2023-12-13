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

function print_matrix(matrix)
    for i in 1:size(matrix, 1)
        for j in 1:size(matrix, 2)
            print(matrix[i, j], "\t")
        end
        println()
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
        print_matrix(mat)
        println()
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
                print_matrix(mat)
                println()
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
        print_matrix(mat)
        println()
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

#=mat = [1 1 1 1 0 0 0 0;
       1 1 0 0 1 1 0 0;
       1 0 1 0 1 0 1 0;
       1 1 1 1 1 1 1 1]=#

       mat1 = genRMC(4)
       matG = genG(mat1, 4, 1)
       print_matrix(matG)
       println()

r = find_rankn(matG)
println(r)


