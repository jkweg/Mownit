using Plots
import Pkg
Pkg.add("TaylorSeries")
using TaylorSeries
using Polynomials

myfun(x) = log(1.0 + x)

stopien_taylora = 6
t = Taylor1(Float64, stopien_taylora)

myfun_taylor = myfun(t)
myfun_t_pol = Polynomial(myfun_taylor.coeffs)
myfun_pade = Polynomials.PolyCompat.PadeApproximation.Pade(myfun_t_pol, 3, 3)


x_geste = range(-0.8, 3.5, length=300)

y_prawdziwe = myfun.(x_geste)
y_taylor = myfun_t_pol.(x_geste)

y_pade = myfun_pade.(x_geste)

p = plot(x_geste, y_prawdziwe, label="Oryginał: log(1+x)", color=:black, linewidth=4, 
         title="Aproksymacja Padé vs Szereg Taylora", xlabel="Oś X", ylabel="Oś Y", legend=:bottomright)

plot!(p, x_geste, y_taylor, label="Taylor (stopień 6) - Ucieka!", color=:red, linewidth=2, linestyle=:dash)

plot!(p, x_geste, y_pade, label="Padé [3/3] - Stabilne", color=:blue, linewidth=3)

plot!(p, ylim=(-2.0, 2.5))

savefig("zad5_pade.png")