@tool
extends EditorPlugin

var editor_selection := get_editor_interface().get_selection()
var selected_polygon2d : Polygon2D = null
var previous_points : PackedVector2Array


func _enter_tree() -> void:
	editor_selection.selection_changed.connect(self._on_selection_changed)
	_on_selection_changed()


func _process(_delta: float) -> void:
	if selected_polygon2d == null:
		return
	if selected_polygon2d.polygon != previous_points:
		triangulate_polygons(selected_polygon2d)
	previous_points = selected_polygon2d.polygon.duplicate()



func _exit_tree() -> void:
	editor_selection.selection_changed.disconnect(self._on_selection_changed)


func _on_selection_changed() -> void:
	var selected_nodes := editor_selection.get_selected_nodes()

	if not selected_nodes.is_empty() and selected_nodes[0] is Polygon2D:
		selected_polygon2d = selected_nodes[0]
		triangulate_polygons(selected_polygon2d)
	else:
		selected_polygon2d = null

func _is_line_in_polygon(a: Vector2, b: Vector2, polygon_verts: PackedVector2Array) -> bool:
	return Geometry2D.is_point_in_polygon(a + a.direction_to(b) * 0.01, polygon_verts) \
		and Geometry2D.is_point_in_polygon(b + b.direction_to(a) * 0.01, polygon_verts) \
		and Geometry2D.is_point_in_polygon((a + b) / 2, polygon_verts)

func triangulate_polygons(polygon2d : Polygon2D) -> void:
	if polygon2d.polygon.size() < 3:
		# Can't triangulate without a triangle...
		return

	polygon2d.polygons = []
	var points = Geometry2D.triangulate_delaunay(polygon2d.polygon)
	var contour_polygon = polygon2d.polygon.slice(0, polygon2d.polygon.size() - polygon2d.internal_vertex_count)
	for point in range(0, points.size(), 3):
		var triangle = []
		triangle.push_back(points[point])
		triangle.push_back(points[point + 1])
		triangle.push_back(points[point + 2])
		var a = polygon2d.polygon[points[point]]
		var b = polygon2d.polygon[points[point + 1]]
		var c = polygon2d.polygon[points[point + 2]]
		var center = (a + b + c) / 3
		# move points inside the triangle so we don't check for intersection with polygon edge
		a = a - (a - center).normalized() * 0.01
		b = b - (b - center).normalized() * 0.01
		c = c - (c - center).normalized() * 0.01
		# if all same points are inside polygon, then add it
		if Geometry2D.is_point_in_polygon(a, contour_polygon) \
			and Geometry2D.is_point_in_polygon(b, contour_polygon) \
			and Geometry2D.is_point_in_polygon(c, contour_polygon):
			polygon2d.polygons.push_back(triangle)

