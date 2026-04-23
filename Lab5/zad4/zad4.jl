using Plots
using Polynomials

f_runge(x) = 1.0 / (1.0 + 25.0 * x^2)
N = 15 

x_geste = range(-1.0, 1.0, length=500)
y_prawdziwe = f_runge.(x_geste)

x_zle = range(-1.0, 1.0, length=N)
y_zle = f_runge.(x_zle)

wielomian_zly = fit(x_zle, y_zle)
y_plot_zle = wielomian_zly.(x_geste)

wspolczynniki = zeros(N + 1)
wspolczynniki[end] = 1.0
T_N = ChebyshevT(wspolczynniki)

x_czeb = roots(T_N)
y_czeb = f_runge.(x_czeb)

wielomian_czeb = fit(ChebyshevT, x_czeb, y_czeb)
y_plot_czeb = wielomian_czeb.(x_geste)

p = plot(x_geste, y_prawdziwe, label="Idealna f. Rungego", color=:black, linewidth=4, 
         title="Zniwelowanie Efektu Rungego (N=$N)", xlabel="X", ylabel="Y", legend=:top)

plot!(p, x_geste, y_plot_zle, label="Równoodległe (BŁĄD!)", color=:red, linewidth=2)
scatter!(p, x_zle, y_zle, color=:red, label="Węzły równoodległe", markersize=4)

plot!(p, x_geste, y_plot_czeb, label="Węzły Czebyszewa (SUKCES)", color=:green, linewidth=2, linestyle=:dash)
scatter!(p, x_czeb, y_czeb, color=:green, label="Węzły Czebyszewa", markersize=6)

plot!(p, ylim=(-0.5, 1.5))

savefig("zad4_czebyszew.png")