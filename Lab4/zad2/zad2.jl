using Plots

struct NewtonInterpolation
    x_nodes::Vector{Float64}
    coefs::Vector{Float64}

    function NewtonInterpolation(x::Vector{Float64}, y::Vector{Float64})
        n = length(x)
        c = copy(y)
        
        for j in 2:n
            for i in n:-1:j
                c[i] = (c[i] - c[i-1]) / (x[i] - x[i-j+1])
            end
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
przedzial_min = -5.0
przedzial_max = 5.0

x_wezly = sort(rand(liczba_wezlow) .* (przedzial_max - przedzial_min) .+ przedzial_min)
y_wezly = rand(liczba_wezlow) .* 10.0

newt = NewtonInterpolation(x_wezly, y_wezly)

x_geste = range(x_wezly[1], x_wezly[end], length=200)

y_wielomian = newt.(x_geste)

p = plot(x_geste, y_wielomian, 
         label="Wielomian Newtona", 
         color=:purple, 
         linewidth=2,
         title="Interpolacja Newtona (Ilorazy różnicowe)",
         xlabel="Oś X", ylabel="Oś Y")

scatter!(p, x_wezly, y_wezly, 
         label="Węzły interpolacji", 
         color=:red, 
         markersize=5, 
         markerstrokecolor=:black)

# display(p)
savefig("wykres_newton.png")