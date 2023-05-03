@tool
extends EditorPlugin

var selected_polygon2d : Polygon2D = null
var previous_points : PackedVector2Array

var _polygon_2d_editor_panels : Array[Panel] = []


func _enter_tree() -> void:
	_polygon_2d_editor_panels = _get_polygon_2d_editor_panels()	


func _process(_delta: float) -> void:
	if selected_polygon2d == null:
		return
	if selected_polygon2d.polygon != previous_points:
		triangulate_polygons(selected_polygon2d)
		# queue the editor for redraw
		_queue_redraw_panels(_polygon_2d_editor_panels)
		
		previous_points = selected_polygon2d.polygon.duplicate()


func _handles(object: Object) -> bool:
	if object is Polygon2D:
		selected_polygon2d = object
		return true
	selected_polygon2d = null
	return false


func triangulate_polygons(polygon2d : Polygon2D) -> void:
	if polygon2d.polygon.size() < 3:
		# Can't triangulate without a triangle...
		return

	polygon2d.polygons = []
	var points = Geometry2D.triangulate_delaunay(polygon2d.polygon)
	# Outer verticies are stored at the beginning of the PackedVector2Array
	var outer_polygon = polygon2d.polygon.slice(0, polygon2d.polygon.size() - polygon2d.internal_vertex_count)
	for point in range(0, points.size(), 3):
		var triangle = []
		triangle.push_back(points[point])
		triangle.push_back(points[point + 1])
		triangle.push_back(points[point + 2])
		
		# only add the triangle if all points are inside the polygon
		var a : Vector2 = polygon2d.polygon[points[point]]
		var b : Vector2 = polygon2d.polygon[points[point + 1]]
		var c : Vector2 = polygon2d.polygon[points[point + 2]]
		
		if _points_are_inside_polygon(a, b, c, outer_polygon):
			polygon2d.polygons.push_back(triangle)


# Find the Panels associated with the Polygon2DEditor node.
func _get_polygon_2d_editor_panels() -> Array[Panel] :
	var panels : Array[Panel] = []
	# Find the editor
	for child in get_editor_interface().get_base_control().find_children("*","Polygon2DEditor", true, false):
		# Find the "uv_edit_draw" panel https://github.com/godotengine/godot/blob/2a0aef5f0912b60f85c9e150cc0bfbeab7de6e40/editor/plugins/polygon_2d_editor_plugin.cpp#L1348
		# Note that this finds multiple panels as all of these nodes are nameless..
		panels.append_array(child.find_children("*", "Panel", true, false))
	return panels


func _queue_redraw_panels(panels: Array[Panel]) -> void:
	for panel in panels:
		if panel.is_visible_in_tree():
			panel.queue_redraw()


func _points_are_inside_polygon(a: Vector2, b: Vector2, c: Vector2, polygon: PackedVector2Array) -> bool:
	var center = (a + b + c) / 3
	# move points inside the triangle so we don't check for intersection with polygon edge
	a = a - (a - center).normalized() * 0.01
	b = b - (b - center).normalized() * 0.01
	c = c - (c - center).normalized() * 0.01
	
	return Geometry2D.is_point_in_polygon(a, polygon) \
		and Geometry2D.is_point_in_polygon(b, polygon) \
		and Geometry2D.is_point_in_polygon(c, polygon)
