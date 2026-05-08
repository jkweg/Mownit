using SpecialPolynomials
using LinearAlgebra 

# Definiujemy przedział i gęstą siatkę (od -10 do 10, żeby uchwycić całe "bicie" funkcji)
xx = -10:0.01:10

# Generujemy nagie wielomiany (rzędu 0, 1, 2, 3)
p0 = basis(Hermite, 0).(xx)
p1 = basis(Hermite, 1).(xx)
p2 = basis(Hermite, 2).(xx)
p3 = basis(Hermite, 3).(xx)

# Sprawdzamy NAGIE wielomiany
println("--- 1. Macierz iloczynów skalarnych (BEZ funkcji wagowej) ---")
dot_nagie = zeros(4, 4)
nagie = [p0, p1, p2, p3]

for i in 1:4, j in 1:4
    dot_nagie[i, j] = dot(nagie[i], nagie[j])
end
# Wyświetlamy zaokrąglone wyniki
display(round.(dot_nagie, digits=2))


# Generujemy znormalizowane funkcje bazowe (Wielomian * funkcja wagowa)
f0 = normalize(p0 .* exp.(-(xx.^2) ./ 2))
f1 = normalize(p1 .* exp.(-(xx.^2) ./ 2))
f2 = normalize(p2 .* exp.(-(xx.^2) ./ 2))
f3 = normalize(p3 .* exp.(-(xx.^2) ./ 2))

println("\n--- 2. Macierz iloczynów skalarnych (Z funkcją wagową) ---")
dot_waga = zeros(4, 4)
waga = [f0, f1, f2, f3]

for i in 1:4, j in 1:4
    dot_waga[i, j] = dot(waga[i], waga[j])
end

display(round.(dot_waga, digits=2))