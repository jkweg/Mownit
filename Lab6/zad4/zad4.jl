using Plots
using SpecialPolynomials
using LinearAlgebra
using CSV
using DataFrames
using Statistics # Potrzebne do funkcji mean()

# 1. Przygotowanie danych (to co w zad. 3)
ekg_data = CSV.read("ecg_data.csv", DataFrame)
xx = ekg_data.time .* 40.0
yy_N = ekg_data.signalN
yy_V = ekg_data.signalV

# Funkcja bazowa
function base_fun(k, x)
    H_k = basis(Hermite, k).(x)
    app = H_k .* exp.(-(x.^2) ./ 2)
    return normalize(app)
end

# Funkcja licząca Błąd Średniokwadratowy (MSE)
mse(prawdziwe, aproksymacja) = mean((prawdziwe .- aproksymacja).^2)

# 2. Inicjalizacja pustych płócien i list na wyniki
stopnie = 0:10
bledy_N = Float64[]
bledy_V = Float64[]

y_app_N = zeros(length(xx))
y_app_V = zeros(length(xx))

# 3. Główna pętla licząca błędy dla kolejnych stopni
for k in stopnie
    f_k = base_fun(k, xx)
    
    # Dodajemy kolejny "klocek" dla sygnału N i mierzymy błąd
    c_k_N = dot(yy_N, f_k)
    y_app_N .+= c_k_N .* f_k
    push!(bledy_N, mse(yy_N, y_app_N))
    
    # Dodajemy kolejny "klocek" dla sygnału V i mierzymy błąd
    c_k_V = dot(yy_V, f_k)
    y_app_V .+= c_k_V .* f_k
    push!(bledy_V, mse(yy_V, y_app_V))
end

# 4. Rysowanie wykresu spadku błędu
p = plot(stopnie, bledy_N, label="Błąd MSE - Typ N (Normalny)", marker=:circle, linewidth=3, color=:blue,
         title="Błąd aproksymacji w zależności od stopnia",
         xlabel="Maksymalny użyty stopień wielomianu (k)", ylabel="Błąd Średniokwadratowy (MSE)")

plot!(p, stopnie, bledy_V, label="Błąd MSE - Typ V (Anomalia)", marker=:square, linewidth=3, color=:red)

# Dodatkowa stylizacja, żeby ładnie było widać "łokieć"
plot!(p, xticks=0:10, legend=:topright)

savefig("zad4_blad_mse.png")