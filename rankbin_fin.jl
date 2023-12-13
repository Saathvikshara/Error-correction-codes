 function swap_rows!(mat, row1, row2)
    mat[row1, :], mat[row2, :] = mat[row2, :], mat[row1, :]
end

function div(a,b)
    if b!=0
        return a
    end
end

function sub(a,b)
    if a==b
        return 0
    else
        return 1
    end
end

#=function mul(a,b)
    if a==1 && b==1
        return 1
    else
        return 0
    end
end=#


function find_rank(mat::Array{T,N}) where {T,N}
    local num_rows
    local num_cols
    try
        num_rows, num_cols = size(mat)
    catch BoundsError
        return 0
    else
    rank = min(num_rows, num_cols)
    for row in 1:rank
        if mat[row, row] == 0
            @views non_zero_row = findfirst(x -> x != 0, mat[row:end, row])
            if non_zero_row === nothing
                rank -= 1
            else
                swap_rows!(mat, row, non_zero_row + row - 1)
            end
        end
        if mat[row, row] != 0  
            @views for next_row in row+1:num_rows
               @inbounds ratio = div.(mat[next_row, row], mat[row, row])
               @inbounds  mat[next_row, :] = sub.(mat[next_row, :], ratio .* mat[row, :])
            end
        end
    end
    return rank
    end
end


#mat=Int8[]
#mat1 = rand(0:1:1,2000,3000) 
#mat=Int8.(mat1)
#=mat = [1 0 0 0 0 0;
       0 1 0 0 0 0;
       0 0 1 0 0 0;
       0 0 0 1 0 0;
       1 0 0 0 0 0;
       0 1 0 0 0 0;
       0 0 0 0 1 0;
       1 1 1 0 0 0 ]=#
mat=[]

println("Rank of the matrix is: ", find_rank(mat))

#@time find_rank(mat)