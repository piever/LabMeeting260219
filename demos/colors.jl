using Interact, Blink, Plots

color = colorpicker()
npoints = slider(10:100, label = "npoints")
markersize = slider(3:10, label = "markersize")
label = textbox("insert legend entry")
plt = Interact.@map scatter(
    rand(&npoints), rand(&npoints),
    color = &color,
    markersize = &markersize,
    label = &label
)

ui = vbox(
    color,
    npoints,
    markersize,
    label,
    plt
)

w = Window()
body!(w, ui)
