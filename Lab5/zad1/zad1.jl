using Plots
using Statistics


# Wersja naiwna (kolejność pętli: i -> j -> k)
function naive_multiplication(A, B)
    C = zeros(Float64, size(A,1), size(B,2))
    for i=1:size(A,1)
        for j=1:size(B,2)
            for k=1:size(A,2)
                C[i,j] = C[i,j] + A[i,k]*B[k,j]
            end
        end
    end
    return C
end

# Wersja ulepszona (kolejność pętli: j -> k -> i)
function better_multiplication(A, B)
    C = zeros(Float64, size(A,1), size(B,2))
    for j=1:size(B,2)
        for k=1:size(A,2)
            for i=1:size(A,1)
                C[i,j] = C[i,j] + A[i,k]*B[k,j]
            end
        end
    end
    return C
end

A_warm = rand(10, 10); B_warm = rand(10, 10)
naive_multiplication(A_warm, B_warm)
better_multiplication(A_warm, B_warm)
A_warm * B_warm

rozmiary = [50, 100, 150, 200, 300, 400] 
liczba_prob = 5 

sr_naive = Float64[]; std_naive = Float64[]
sr_better = Float64[]; std_better = Float64[]
sr_blas = Float64[]; std_blas = Float64[]

println("Rozpoczynam pomiary... to potrwa kilkanaście sekund.")

for N in rozmiary
    czasy_naive = zeros(liczba_prob)
    czasy_better = zeros(liczba_prob)
    czasy_blas = zeros(liczba_prob)
    
    for p in 1:liczba_prob
        A = rand(N, N)
        B = rand(N, N)
        
        czasy_naive[p]  = @elapsed naive_multiplication(A, B)
        czasy_better[p] = @elapsed better_multiplication(A, B)
        czasy_blas[p]   = @elapsed A * B 
    end
    
    push!(sr_naive, mean(czasy_naive));   push!(std_naive, std(czasy_naive))
    push!(sr_better, mean(czasy_better)); push!(std_better, std(czasy_better))
    push!(sr_blas, mean(czasy_blas));     push!(std_blas, std(czasy_blas))
    
    println("Zakończono pomiar dla macierzy $N x $N")
end

p = plot(rozmiary, sr_naive, yerr=std_naive, label="Naiwna (i-j-k)", marker=:circle, linewidth=2, color=:red,
         title="Czas mnożenia macierzy w zależności od jej rozmiaru",
         xlabel="Rozmiar macierzy (N)", ylabel="Średni Czas [s]", legend=:topleft)

plot!(p, rozmiary, sr_better, yerr=std_better, label="Ulepszona (j-k-i)", marker=:square, linewidth=2, color=:blue)
plot!(p, rozmiary, sr_blas, yerr=std_blas, label="BLAS (A * B)", marker=:utriangle, linewidth=2, color=:green)

# display(p)
savefig("zad1_mnozenie_macierzy.png")