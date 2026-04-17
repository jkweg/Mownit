using Pkg
using Plots

function lagrange_interpolate(x_nodes, y_nodes, x_val)
    n = length(x_nodes)
    wynik = 0.0
    
    for i in 1:n
        L_i = 1.0
        for j in 1:n
            if i != j
                L_i = L_i * (x_val - x_nodes[j]) / (x_nodes[i] - x_nodes[j])
            end
        end
        
        wynik += y_nodes[i] * L_i
    end
    
    return wynik
end

przedzial_min = -5.0
przedzial_max = 5.0
liczba_wezlow = 8

x_wezly = sort(rand(liczba_wezlow) .* (przedzial_max - przedzial_min) .+ przedzial_min)
y_wezly = rand(liczba_wezlow) .* 10.0

x_geste = range(x_wezly[1], x_wezly[end], length=200)
y_wielomian = lagrange_interpolate.(Ref(x_wezly), Ref(y_wezly), x_geste)

p = plot(x_geste, y_wielomian, 
         label="Wielomian Lagrange'a", 
         color=:blue, 
         linewidth=2,
         title="Interpolacja Wielomianowa Lagrange'a",
         xlabel="Oś X", 
         ylabel="Oś Y")

scatter!(p, x_wezly, y_wezly, 
         label="Węzły interpolacji", 
         color=:red, 
         markersize=5, 
         markerstrokecolor=:black)

# display(p)
savefig("interpolacja_lagrange.png")