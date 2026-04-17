using Plots
using Polynomials
using Statistics


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

function newton_coef(x, y)
    n = length(x)
    c = copy(y)
    for j in 2:n, i in n:-1:j
        c[i] = (c[i] - c[i-1]) / (x[i] - x[i-j+1])
    end
    return c
end

function newton_eval(x, c, x_val)
    val = c[end]
    for i in length(c)-1:-1:1
        val = c[i] + (x_val - x[i]) * val
    end
    return val
end

lagrange_interpolate([1.0, 2.0], [1.0, 2.0], 1.5)
newton_eval([1.0, 2.0], newton_coef([1.0, 2.0], [1.0, 2.0]), 1.5)
fit([1.0, 2.0], [1.0, 2.0])(1.5)

rozmiary = [10, 50, 100, 200, 300, 500]
liczba_prob = 10
x_test = 0.5

sr_bud_n = Float64[]; odch_bud_n = Float64[]
sr_ewal_n = Float64[]; odch_ewal_n = Float64[]

sr_bud_p = Float64[]; odch_bud_p = Float64[]
sr_ewal_p = Float64[]; odch_ewal_p = Float64[]

sr_ewal_l = Float64[]; odch_ewal_l = Float64[] 

println("Rozpoczynam pomiary z dodanym Lagrange'm...")

for n in rozmiary
    x_nodes = collect(1.0:n)
    y_nodes = rand(n)
    
    czasy_bud_n = zeros(liczba_prob); czasy_ewal_n = zeros(liczba_prob)
    czasy_bud_p = zeros(liczba_prob); czasy_ewal_p = zeros(liczba_prob)
    czasy_ewal_l = zeros(liczba_prob)
    
    for i in 1:liczba_prob
        czasy_bud_n[i] = @elapsed c = newton_coef(x_nodes, y_nodes)
        czasy_ewal_n[i] = @elapsed newton_eval(x_nodes, c, x_test)
        
        czasy_bud_p[i] = @elapsed wielomian = fit(x_nodes, y_nodes)
        czasy_ewal_p[i] = @elapsed wielomian(x_test)
        
        czasy_ewal_l[i] = @elapsed lagrange_interpolate(x_nodes, y_nodes, x_test)
    end
    
    push!(sr_bud_n, mean(czasy_bud_n)); push!(odch_bud_n, std(czasy_bud_n))
    push!(sr_ewal_n, mean(czasy_ewal_n)); push!(odch_ewal_n, std(czasy_ewal_n))
    
    push!(sr_bud_p, mean(czasy_bud_p)); push!(odch_bud_p, std(czasy_bud_p))
    push!(sr_ewal_p, mean(czasy_ewal_p)); push!(odch_ewal_p, std(czasy_ewal_p))
    
    push!(sr_ewal_l, mean(czasy_ewal_l)); push!(odch_ewal_l, std(czasy_ewal_l))
end


p1 = plot(rozmiary, sr_bud_n, yerr=odch_bud_n, label="Newton", marker=:circle, 
          title="Czas TWORZENIA", xlabel="Liczba węzłów", ylabel="Czas [s]", color=:green)
plot!(p1, rozmiary, sr_bud_p, yerr=odch_bud_p, label="Polynomials", marker=:square, color=:blue)

p2 = plot(rozmiary, sr_ewal_n, yerr=odch_ewal_n, label="Newton", marker=:circle, 
          title="Czas EWALUACJI", xlabel="Liczba węzłów", ylabel="Czas [s]", color=:green)
plot!(p2, rozmiary, sr_ewal_p, yerr=odch_ewal_p, label="Polynomials", marker=:square, color=:blue)
plot!(p2, rozmiary, sr_ewal_l, yerr=odch_ewal_l, label="Lagrange", marker=:utriangle, color=:red)

wykres = plot(p1, p2, layout=(1,2), size=(1000, 500), margin=5Plots.mm)
display(wykres)
savefig("zadanie4_pomiary_czasu_z_lagrangem.png")