using Plots
using Polynomials

function lagrange_interpolate(x_nodes, y_nodes, x_val)
    n = length(x_nodes)
    wynik = 0.0
    for i in 1:n
        L_i = 1.0
        for j in 1:n
            if i != j
                L_i *= (x_val - x_nodes[j]) / (x_nodes[i] - x_nodes[j])
            end
        end
        wynik += y_nodes[i] * L_i
    end
    return wynik
end

struct NewtonInterpolation
    x_nodes::Vector{Float64}
    coefs::Vector{Float64}

    function NewtonInterpolation(x::Vector{Float64}, y::Vector{Float64})
        n = length(x)
        c = copy(y)
        for j in 2:n, i in n:-1:j
            c[i] = (c[i] - c[i-1]) / (x[i] - x[i-j+1])
        end
        return new(x, c)
    end
end

function (interp::NewtonInterpolation)(x_val::Float64)
    c = interp.coefs
    x = interp.x_nodes
    n = length(c)
    val = c[n]
    for i in n-1:-1:1
        val = c[i] + (x_val - x[i]) * val
    end
    return val
end


liczba_wezlow = 8
x_wezly = sort(rand(liczba_wezlow) .* 10.0 .- 5.0)
y_wezly = rand(liczba_wezlow) .* 10.0

x_geste = range(x_wezly[1], x_wezly[end], length=200)

y_lagrange = lagrange_interpolate.(Ref(x_wezly), Ref(y_wezly), x_geste)

newt = NewtonInterpolation(x_wezly, y_wezly)
y_newton = newt.(x_geste)

poly_fit = fit(x_wezly, y_wezly)
y_poly = poly_fit.(x_geste)


p = scatter(x_wezly, y_wezly, label="Węzły", color=:black, markersize=6, title="Porównanie 3 metod interpolacji")

plot!(p, x_geste, y_lagrange, label="Lagrange", color=:red, linewidth=8, alpha=0.4)
plot!(p, x_geste, y_newton, label="Newton", color=:green, linewidth=4, linestyle=:dash)
plot!(p, x_geste, y_poly, label="Polynomials", color=:blue, linewidth=1.5, linestyle=:dot)

display(p)

savefig("zadanie3_porownanie.png")