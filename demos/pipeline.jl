using JuliaDBMeta, TableWidgets, StatsPlots, Interact, Blink
fn = filepicker()
placeholder = table((a = ["Load a real table"],))
input_data = Interact.@map isempty(&fn) ? placeholder : loadtable(&fn)
filtered_data = selectors(input_data)
edited_data = dataeditor(filtered_data)
viewer = dataviewer(edited_data)
tabs = OrderedDict(
    :filename => fn,
    :filtered_data => filtered_data,
    :edited_data => edited_data,
    :viewer => viewer
)
ui = tabulator(tabs)
w = Window()
body!(w, ui)
