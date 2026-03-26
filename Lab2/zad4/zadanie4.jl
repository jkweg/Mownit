using DataFrames
using CSV
using Plots

# Niestabilnie, bo odejmowanie
function f_unstable(x::Float64)
    return sqrt(x + 1.0) - sqrt(x)
end

# Stabilnie , bo dodawanie
function f_stable(x::Float64)
    return 1.0 / (sqrt(x + 1.0) + sqrt(x))
end

x_vals = [10.0^i for i in 0:18]

df = DataFrame(
    Wartosc_X = x_vals,
    Wynik_Niestabilny = f_unstable.(x_vals),
    Wynik_Stabilny = f_stable.(x_vals)
)

plik = "stabilnosc_numeryczna.csv"
CSV.write(plik, df)
println("Dane pomyślnie zapisano do pliku: ", plik)

y_niestabilne = [y == 0.0 ? NaN : y for y in df.Wynik_Niestabilny]

p = plot(df.Wartosc_X, [df.Wynik_Stabilny, y_niestabilne],
    label=["Wersja stabilna" "Wersja niestabilna (błąd!)"],
    xaxis=:log10, 
    yaxis=:log10,
    xlabel="Wartość X (skala log)", 
    ylabel="Wynik funkcji f(x) (skala log)",
    title="Kasowanie cyfr znaczących (Cancellation)",
    linewidth=2, 
    marker=:circle,
    legend=:bottomleft,
    size=(800, 500),
    margin=5Plots.mm
)


savefig("wykres_niestabilnosci.png")