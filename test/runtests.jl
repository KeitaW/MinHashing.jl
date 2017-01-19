using MinLSH
using Base.Test

numband = 5
bandwidth = 20
lsh_vars = LSH_vars(numband, bandwidth)
ret_prob_table(numband, bandwidth)

@testset "member" begin
@test lsh_vars.numband   == numband
@test lsh_vars.bandwidth == bandwidth
@test lsh_vars.numhash   == numband * bandwidth
end

# generate_signature_matrixで作成したsignature_matrixが正しくJaccard係数近似になっているかどうかのテスト
a = zeros(Bool, 20, 10)
# a[1:5, :] = 1
a[2:7, 1] = 1
a[2:8, 2] = 1
a[2:5, 3] = 1
a[7:8, 4] = 1
a[:, 6] = 1
a[:, 7] = 1
jaccard(set1::Set{UInt}, set2::Set{UInt}) = length(set1 ∩ set2) / length(set1 ∪ set2) 
# sbinvec: sparse (CSC) binary vector
function jaccard(sbinvec1::SparseVector{Bool, Int64}, sbinvec2::SparseVector{Bool, Int64})
    set1 = Set{UInt}(findn(sbinvec1 .== 1))
    set2 = Set{UInt}(findn(sbinvec2 .== 1))
    return(jaccard(set1, set2))
end

b = sparse(a)
sigmat = generate_signature_matrix(lsh_vars, b, window_num = 1, slidewidth = 1)
ethreshould = 3e-2
print_with_color(:red, "estimation error within "*string(ethreshould)*" are allowed \n")
testcols = [(1, 2), (2, 3), (2, 4)]
for (col1, col2) in testcols
    count = 0
    for row in 1:size(sigmat)[1]
        if sigmat[row, col1] == sigmat[row, col2]
            count += 1
        end
    end
    estimated = count / size(sigmat)[1]
    @show jaccard(b[:, col1], b[:, col2]) - estimated
    @test_approx_eq_eps jaccard(b[:, col1], b[:, col2]) estimated ethreshould
end

