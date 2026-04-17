using Plots
using Polynomials
using Interpolations

f_runge(x) = 1.0 / (1.0 + 25.0 * x^2)

przedzial_min = -1.0
przedzial_max = 1.0
liczba_wezlow = 11

x_wezly_zakres = range(przedzial_min, przedzial_max, length=liczba_wezlow)
y_wezly = f_runge.(x_wezly_zakres)

x_wezly_wektor = collect(x_wezly_zakres)

x_geste = range(przedzial_min, przedzial_max, length=500)
y_prawdziwe = f_runge.(x_geste)

wielomian = fit(x_wezly_wektor, y_wezly)
y_wielomian = wielomian.(x_geste)

splajn_liniowy = linear_interpolation(x_wezly_zakres, y_wezly)
y_liniowe = splajn_liniowy.(x_geste)

splajn_szescienny = cubic_spline_interpolation(x_wezly_zakres, y_wezly)
y_szescienne = splajn_szescienny.(x_geste)


p = plot(x_geste, y_prawdziwe, label="Oryginalna f. Rungego", color=:black, linewidth=4, 
         title="Efekt Rungego (N=$liczba_wezlow)", xlabel="Oś X", ylabel="Oś Y")

plot!(p, x_geste, y_wielomian, label="Wielomian (błąd na brzegach!)", color=:red, linewidth=2)
plot!(p, x_geste, y_liniowe, label="Splajn Liniowy (stopień 1)", color=:green, linestyle=:dash, linewidth=2)
plot!(p, x_geste, y_szescienne, label="Splajn Sześcienny (stopień 3)", color=:blue, linestyle=:dot, linewidth=3)

scatter!(p, x_wezly_wektor, y_wezly, label="Węzły", color=:black, markersize=5)

plot!(p, ylim=(-0.5, 1.5))

savefig("zadanie6_efekt_rungego.png")