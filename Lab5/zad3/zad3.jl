using Plots
using Polynomials

function naive_mult(A, B)
    C = zeros(size(A,1), size(B,2))
    for i=1:size(A,1), j=1:size(B,2), k=1:size(A,2)
        C[i,j] += A[i,k]*B[k,j]
    end
    return C
end

function better_mult(A, B)
    C = zeros(size(A,1), size(B,2))
    for j=1:size(B,2), k=1:size(A,2), i=1:size(A,1)
        C[i,j] += A[i,k]*B[k,j]
    end
    return C
end

rozmiary = [50, 100, 150, 200, 250]
sr_naive = Float64[]; sr_better = Float64[]; sr_blas = Float64[]

println("Generowanie danych do aproksymacji... proszę czekać.")
for N in rozmiary
    A = rand(N, N); B = rand(N, N)
    
    if N == 50 
        naive_mult(rand(2,2), rand(2,2)); better_mult(rand(2,2), rand(2,2)) 
    end
    
    push!(sr_naive, @elapsed naive_mult(A, B))
    push!(sr_better, @elapsed better_mult(A, B))
    push!(sr_blas, @elapsed A * B)
end
println("Dane zebrane! Rysuję krzywe...")


stopien = 3

poly_naive  = fit(rozmiary, sr_naive, stopien)
poly_better = fit(rozmiary, sr_better, stopien)
poly_blas   = fit(rozmiary, sr_blas, stopien)

x_geste = range(rozmiary[1], rozmiary[end], length=100)

p = scatter(rozmiary, sr_naive, label="Punkty Naiwna", color=:red, markersize=5)
plot!(p, x_geste, poly_naive.(x_geste), label="Aproks. Naiwna O(N^3)", color=:red, linewidth=2)

scatter!(p, rozmiary, sr_better, label="Punkty Ulepszona", color=:blue, markersize=5)
plot!(p, x_geste, poly_better.(x_geste), label="Aproks. Ulepszona O(N^3)", color=:blue, linewidth=2)

scatter!(p, rozmiary, sr_blas, label="Punkty BLAS", color=:green, markersize=5)
plot!(p, x_geste, poly_blas.(x_geste), label="Aproks. BLAS O(N^3)", color=:green, linewidth=2)

plot!(p, title="Aproksymacja czasów wielomianem 3. stopnia", 
         xlabel="Rozmiar macierzy (N)", 
         ylabel="Czas wykonania [s]", 
         legend=:topleft)

display(p)
savefig(joinpath(@__DIR__, "zad3_aproksymacja.png"))
