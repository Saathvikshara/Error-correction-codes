function genBC(m)
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

function display_matrix(mat::AbstractMatrix)
    rows, cols = size(mat)
    
    for i in 1:rows
        for j in 1:cols
            print(mat[i, j])
            if j < cols
                print("\t")  # adjust the spacing as needed
            end
        end
        println()
    end
end

mat=genBC(7)
#display_matrix(mat)
println(size(mat))
mat1=genG(mat,5)
println(size(mat1))
