# using Pkg
# Pkg.add("SpecialPolynomials")

using Plots
using SpecialPolynomials

x_geste = range(-4.0, 4.0, length=400)

p1 = plot(title="Nage Wielomiany Hermite'a", xlabel="x", ylabel="Wartość", legend=:top)

for m in 0:5
    # Funkcja basis(Hermite, m) generuje wielomian m-tego stopnia
    y_poly = basis(Hermite, m).(x_geste)
    plot!(p1, x_geste, y_poly, label="m = $m", linewidth=2)
end


plot!(p1, ylim=(-40, 40))


p2 = plot(title="Ujarzmione Funkcje Bazowe", xlabel="x", ylabel="Wartość", legend=:topright)

for m in 0:5
    y_poly = basis(Hermite, m).(x_geste)
    # Mnożymy przez funkcję wagową (dzwon Gaussa)
    y_baza = y_poly .* exp.(-(x_geste.^2) ./ 2)
    plot!(p2, x_geste, y_baza, label="m = $m", linewidth=2)
end

plot!(p2, ylim=(-3, 3))


wykres_koncowy = plot(p1, p2, layout=(1,2), size=(1000, 500), margin=5Plots.mm)
display(wykres_koncowy)

savefig("zad1_hermite_porownanie.png")