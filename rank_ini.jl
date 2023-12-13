array = [1.0 2.0 -1.0 3.0;
         3.0 4.0 0.0 -1.0;
         -1.0 0.0 -2.0 7.0]

m, n = size(array)

function swap(r1, r2, c)
    for i in 1:c
        t = array[r1, i]
        array[r1, i] = array[r2, i]
        array[r2, i] = t
    end
end

function rank(r, c)
    rank = min(m, n)
    for i in 1:rank
        if array[i, i] != 0
            for j in 1:r
                if j != i
                    ratio = array[j, i] / array[i, i]
                    for k in 1:c
                        array[j, k] -= ratio * array[i, k]
                    end
                end
            end
        else
            swapped = false
            for j in i+1:r
                if array[j, i] != 0
                    swap(i, j, c)
                    swapped = true
                    break
                end
            end
            if !swapped
                rank -= 1
                for j in 1:r
                    array[j, i] = array[j, rank]
                end
                i -= 1
            end
        end
    end
    return rank
end

r1 = rank(m, n)
println("The rank of the matrix is: ", r1)