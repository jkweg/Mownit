using Polynomials

function neville(x_nodes::Vector{Float64}, y_nodes::Vector{Float64}, x_val::Float64)
    n = length(x_nodes)
    

    P = copy(y_nodes)
    
    for j in 2:n
        for i in n:-1:j
            P[i] = ((x_val - x_nodes[i-j+1]) * P[i] - (x_val - x_nodes[i]) * P[i-1]) / (x_nodes[i] - x_nodes[i-j+1])
        end
    end
    
    return P[n]
end


x_wezly = [1.0, 2.0, 3.0, 4.0, 5.0]
y_wezly = [2.1, 3.2, 1.5, 4.8, 5.0]

punkty_testowe = [1.5, 2.5, 3.5, 4.5, 6.0]

poly_fit = fit(x_wezly, y_wezly)

println("--- PORÓWNANIE METOD ---")
println("Węzły X: ", x_wezly)
println("Węzły Y: ", y_wezly)
println("-"^40)

for pt in punkty_testowe
    wynik_neville = neville(x_wezly, y_wezly, pt)
    
    wynik_poly = poly_fit(pt)
    
    blad = abs(wynik_neville - wynik_poly)
    
    println("Punkt X = $pt")
    println("  Neville:     $wynik_neville")
    println("  Polynomials: $wynik_poly")
    println("  Błąd:        $blad")
    println()
end