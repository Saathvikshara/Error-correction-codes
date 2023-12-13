using LinearAlgebra

function swap_rows!(mat, row1, row2)
    mat[row1, :], mat[row2, :] = mat[row2, :], mat[row1, :]
end
function is_almost_zero(x, num_zeros=5)
    decimal_part = abs(x) - floor(abs(x))
    return decimal_part < 1.0 / 10^num_zeros
end

function find_rank(mat)
    num_rows, num_cols = size(mat)
    rank = min(num_rows, num_cols)
    
    for row in 1:rank
        if  is_almost_zero(mat[row, row])
            non_zero_row = findfirst(x -> !is_almost_zero(x), mat[row:end, row])
            if non_zero_row === nothing
                rank -= 1
                for j in 1:num_rows
                    mat[j,row]=mat[j,num_cols]
                end
                
            else
                swap_rows!(mat, row, non_zero_row + row - 1)
                
                break
            end
            row-=1
        end
        
        if  !is_almost_zero(mat[row, row])
            for next_row in row+1:num_rows
                ratio = mat[next_row, row] / mat[row, row]
                mat[next_row, :] -= ratio * mat[row, :]
                
            end
        end
    end
    
    return rank
end

function create_matrix_with_rank(rows, cols, target_rank)
    if target_rank > min(rows, cols)
        println("Error: Target rank cannot exceed the minimum of rows and columns.")
        return nothing
    end
    
    # Create a random matrix
    random_matrix = rand(10:1000,rows, cols)
    
    # Perform singular value decomposition (SVD) to get the U, Σ, and Vt matrices
    U, Σ, Vt = svd(random_matrix)
    
    # Modify Σ to achieve the target rank
    Σ[target_rank+1:end] .= 0
    
    # Reconstruct the matrix using modified U, Σ, and Vt matrices
    matrix_with_target_rank = U * Diagonal(Σ) * Vt'
    return matrix_with_target_rank
end

# Example usage:
rows = 400
cols = 300
target_rank = 223

matrix_with_target_rank = create_matrix_with_rank(rows, cols, target_rank)

#println(matrix_with_target_rank)
println("Rank from custom function: ", find_rank(matrix_with_target_rank))
println("Rank from inbuilt function: ", rank(matrix_with_target_rank))
