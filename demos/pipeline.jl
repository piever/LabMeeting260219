using JuliaDBMeta, TableWidgets, StatsPlots, Interact, Blink

function pipeline(table; loader = nothing)
    filtered_data = selectors(table)
    edited_data = dataeditor(filtered_data)
    viewer = dataviewer(edited_data)
    tabs = OrderedDict(
        :filename => loader,
        :filtered_data => filtered_data,
        :edited_data => edited_data,
        :viewer => viewer
    )
    tabulator(tabs)
end
function pipeline()
    loader = filepicker()
    ui = Observable{Any}(loader)
    # initialize the widget as a filepicker, when the filepicker gets used, replace with the output of `myui` called with the loaded table
    Interact.@map! ui pipeline(loadtable(&loader), loader = loader)
    ui
end

w = Window()
body!(w, pipeline())
