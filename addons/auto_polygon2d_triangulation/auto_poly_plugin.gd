@tool
extends EditorPlugin

var editor_selection := get_editor_interface().get_selection()
var selected_polygon2d : Polygon2D = null
var current_polygon_count : int = 0


func _enter_tree() -> void:
	editor_selection.selection_changed.connect(self._on_selection_changed)
	_on_selection_changed()


func _process(_delta: float) -> void:
	if selected_polygon2d :
		if selected_polygon2d.polygon.size() != current_polygon_count:
			triangulate_polygons(selected_polygon2d)
			current_polygon_count = selected_polygon2d.polygon.size()



func _exit_tree() -> void:
	editor_selection.selection_changed.disconnect(self._on_selection_changed)


func _on_selection_changed() -> void:
	var selected_nodes := editor_selection.get_selected_nodes()

	if not selected_nodes.is_empty() and selected_nodes[0] is Polygon2D:
		selected_polygon2d = selected_nodes[0]
		current_polygon_count = selected_polygon2d.polygon.size()
	else:
		selected_polygon2d = null
		current_polygon_count = 0

func triangulate_polygons(polygon2d : Polygon2D) -> void:
	print("triangulate_polygons")
	if polygon2d.polygon.size() < 3:
		# Can't triangulate without a triangle...
		return

	polygon2d.polygons = []

	var delaunay_points = Geometry2D.triangulate_delaunay(polygon2d.polygon)

	for point in range(0, delaunay_points.size(), 3):
		var triangle = []
		triangle.push_back(delaunay_points[point])
		triangle.push_back(delaunay_points[point + 1])
		triangle.push_back(delaunay_points[point + 2])

		polygon2d.polygons.push_back(triangle)

