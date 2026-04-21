class_name CameraZone extends Node2D


@export_custom(PROPERTY_HINT_LINK, "suffix:") var camera_zoom: Vector2 = Vector2(1.8, 1.8)

@onready var jurisdiction: Polygon2D = $Jurisdiction
var jurisdiction_aabb: Rect2


func _ready() -> void:
	jurisdiction.hide()
	_precompute_aabb()

func contains_point(point: Vector2) -> bool:
	if not jurisdiction or not jurisdiction_aabb.has_point(point):
		return false
	
	var world_points: = _get_world_polygon(jurisdiction)
	return Geometry2D.is_point_in_polygon(point, world_points)

func _precompute_aabb():
	# expand Rect2 to fit all polygon points
	var world_points: = _get_world_polygon(jurisdiction)
	jurisdiction_aabb = Rect2(world_points[0], Vector2.ZERO)
	for point in world_points:
		jurisdiction_aabb = jurisdiction_aabb.expand(point)

func _get_world_polygon(poly: Polygon2D) -> PackedVector2Array:
	# get polygon points in world space
	var pts: = poly.polygon
	var world: = PackedVector2Array()
	
	world.resize(pts.size())
	for i in pts.size():
		world[i] = poly.to_global(pts[i])
	
	return world
