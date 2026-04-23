using Plots
using DelimitedFiles

# Wczytujemy dane z pliku CSV wygenerowanego przez C
# (pomijamy pierwszy wiersz, bo to nagłówek)
dane = readdlm("wyniki_c.csv", ',', skipstart=1)

rozmiary = dane[:, 1]
czasy_naiwna = dane[:, 2]
czasy_ulepszona = dane[:, 3]
czasy_blas = dane[:, 4]

# Rysujemy wykres
p = plot(rozmiary, czasy_naiwna, label="C: Naiwna (i-j-k)", marker=:circle, linewidth=2, color=:red,
         title="Czas mnożenia macierzy (Język C, Optymalizacja -O0)",
         xlabel="Rozmiar macierzy (N)", ylabel="Średni Czas [s]", legend=:topleft)

plot!(p, rozmiary, czasy_ulepszona, label="C: Ulepszona (i-k-j)", marker=:square, linewidth=2, color=:blue)
plot!(p, rozmiary, czasy_blas, label="C: BLAS (cblas_dgemm)", marker=:utriangle, linewidth=2, color=:green)

# display(p)
savefig("zad2_mnozenie_macierzy_C.png")