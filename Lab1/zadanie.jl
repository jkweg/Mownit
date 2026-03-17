using LinearAlgebra
using DataFrames
using CSV
using Plots
using Statistics


rozmiary = [1000, 2000, 3000, 5000, 10000,15000,20000,25000]
pomiary = 10

_x = rand(2)
_y = rand(2)
_A = rand(2, 2)
dot(_x, _A, _y)
_A * _x

wyniki = DataFrame(Size = Int[], Operation = String[], Time = Float64[])

println("Rozpoczynam pomiary...")

for n in rozmiary
    for i in 1:pomiary
        x = rand(n)
        y = rand(n)
        A = rand(n, n)
        
        t_dot = @elapsed dot(x, A, y)
        push!(wyniki, (n, "dot(x,A,y)", t_dot))
        
        t_mul = @elapsed A * x
        push!(wyniki, (n, "A*x", t_mul))
    end
end

println("Pomiary zakończone.")

plik = "wyniki_pomiarow.csv"
CSV.write(plik, wyniki)
println("Wyniki zapisane do pliku $plik")

df_loaded = CSV.read(plik, DataFrame)

df_stats = combine(groupby(df_loaded, [:Size, :Operation]), 
                   :Time => mean => :MeanTime, 
                   :Time => std => :StdTime)

df_dot = filter(row -> row.Operation == "dot(x,A,y)", df_stats)
df_mul = filter(row -> row.Operation == "A*x", df_stats)

p1 = plot(df_dot.Size, df_dot.MeanTime, yerror=df_dot.StdTime, 
          label="dot(x,A,y)", 
          xlabel="Rozmiar wektora (n)", 
          ylabel="Średni czas (s)", 
          title="Czas iloczynu skalarnego", 
          marker=:circle, color=:blue, legend=:topleft)

p2 = plot(df_mul.Size, df_mul.MeanTime, yerror=df_mul.StdTime, 
          label="A * x", 
          xlabel="Rozmiar wektora (n)", 
          ylabel="Średni czas (s)", 
          title="Czas mnożenia macierz*wektor", 
          marker=:circle, color=:red, legend=:topleft)

final_plot = plot(p1, p2, layout=(1, 2), size=(900, 450), margin=5Plots.mm)
display(final_plot)
savefig("wykres_czasow.png")