using Plots
using SpecialPolynomials
using LinearAlgebra
using CSV
using DataFrames

# 1. Wczytanie danych z pliku EKG 
ekg_data = CSV.read("ecg_data.csv", DataFrame)

# 2. Skalowanie osi X (bardzo ważny krok, wyjaśnienie poniżej!)
xx = ekg_data.time .* 40.0
yy_N = ekg_data.signalN
yy_V = ekg_data.signalV

# 3. Zdefiniowanie funkcji generującej nasze "klocki LEGO" (znormalizowana baza)
function base_fun(k, x)
    H_k = basis(Hermite, k).(x)        # Surowy wielomian
    app = H_k .* exp.(-(x.^2) ./ 2)    # Nałożenie "kagańca" Gaussa z Zadania 1
    return normalize(app)              # Ustawienie długości wektora na 1 (Ortonormalność z Zadania 2)
end

# 4. Uniwersalna funkcja do rysowania aproksymacji dla danego sygnału
function aproksymuj_ekg(x, y, tytul)
    p = plot(x, y, label="Oryginalny sygnał", color=:black, linewidth=4, 
             title=tytul, xlabel="Czas (przeskalowany)", ylabel="Napięcie", legend=:bottomright)
    
    y_app = zeros(length(x)) # Tworzymy "puste płótno" z samymi zerami
    
    # Będziemy dodawać kolejne "klocki" (stopnie wielomianu) od 0 do 5
    for k in 0:5
        f_k = base_fun(k, x)       # 1. Weź klocek o kształcie 'k'
        c_k = dot(y, f_k)          # 2. Oblicz ile tego klocka potrzebujemy (iloczyn skalarny)
        y_app .+= c_k .* f_k       # 3. Wymnóż klocek przez tę ilość i dorzuć do naszego płótna
        
        # Nie rysujemy każdego stopnia, żeby nie zrobić bałaganu. Rysujemy wynik po dodaniu stopnia 1, 3 i 5.
        if k in [1, 3, 5]
            plot!(p, x, y_app, label="Użyto stopni: 0 do $k", linewidth=2)
        end
    end
    return p
end

# 5. Odpalamy funkcję dla obu typów uderzeń serca
wykres_N = aproksymuj_ekg(xx, yy_N, "Zespół QRS - Typ N (Normalny)")
wykres_V = aproksymuj_ekg(xx, yy_V, "Zespół QRS - Typ V (Anomalia)")

# 6. Rysujemy jeden pod drugim
wykres_koncowy = plot(wykres_N, wykres_V, layout=(2,1), size=(800, 700), margin=5Plots.mm)

savefig("zad3_ekg_aproksymacja.png")