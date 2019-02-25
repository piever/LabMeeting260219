using Interact, Blink, Plots

function create_ui()
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

    vbox(
        color,
        npoints,
        markersize,
        label,
        plt
    )
end

w = Window()
body!(w, create_ui())
