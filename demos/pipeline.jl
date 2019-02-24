using JuliaDBMeta, TableWidgets, StatsPlots, Interact, Blink

function pipeline(input_data)
    filtered_data = selectors(input_data)
    edited_data = dataeditor(filtered_data)
    viewer = dataviewer(edited_data)
    tabs = OrderedDict(
        :filtered_data => filtered_data,
        :edited_data => edited_data,
        :viewer => viewer
    )
    tabulator(tabs)
end

fn = filepicker()
tabs = Interact.@map isempty(&fn) ? nothing : pipeline(loadtable(&fn))
ui = Widgets.div(fn, tabs)

w = Window()
body!(w, ui)
