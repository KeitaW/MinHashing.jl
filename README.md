# Min Hashing
JuliaLang implementation of Min Hashing algorithm descrived in the following paper,
Cohen, E., Datar, M., Fujiwara, S., Gionis, A., Indyk, P., Motwani, R., et al. (2001). Finding interesting associations without support pruning. Knowledge and Data Engineering, IEEE Transactions on, 13(1), 64–78. http://doi.org/10.1109/69.908981

## Usage
```julia
numband = 2
bandwidth = 5
lsh_vars = LSH_vars(numband, bandwidth)

a = zeros(Bool, 20, 10)
a[2:7, 1] = 1
a[2:8, 2] = 1
a[2:5, 3] = 1
a[7:8, 4] = 1
a[:, 6] = 1
a[:, 7] = 1
# This library assumes input to be sparse matrix.
b = sparse(a)
sigmat = generate_signature_matrix(lsh_vars, b, window_num = 1, slidewidth = 1)
bucket_list = generate_buckets(lsh_vars, sigmat)
# Find which columns are similar to the first column in the sense of Jaccard similarity.
@show find_similar(lsh_vars, sigmat, bucket_list, 1) # Output: Set([2, 1]) that means the first and second columns are similar.
```

