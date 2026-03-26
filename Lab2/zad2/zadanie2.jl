using Plots

x_vals = 1.0:    100.0:   1000000.0

distances = eps.(x_vals)

p = plot(x_vals, distances, 
         xlabel = "Wartość liczby (x)", 
         ylabel = "Odległość do następnej liczby (eps)",
         title = "Rozdzielczość liczb zmiennoprzecinkowych (Float64)",
         legend = false,
         linewidth = 2,
         color = :blue,
         grid = true)

savefig("wykres_odleglosci_zadanie2.png")