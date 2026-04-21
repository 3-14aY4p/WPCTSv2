extends Camera2D


@onready var player: Player = $".."

var tilemap: TileMapLayer
var all_areas: Array[CameraZone] = []
var current_area: CameraZone

func _ready() -> void:
	await get_tree().process_frame

func _process(delta: float) -> void:
	all_areas.assign(get_tree().get_nodes_in_group("camera_area"))
	
	tilemap = get_tree().get_first_node_in_group("camera_bounds")
	setup_camera_limits()
	_find_current_area()

func setup_camera_limits():
	if not tilemap:
		return
		
	var tilemap_size := tilemap.tile_set.get_tile_size()
	var used_rect : Rect2i = tilemap.get_used_rect()
	
	limit_top = used_rect.position.y * tilemap_size.y
	limit_bottom = (used_rect.position.y + used_rect.size.y) * tilemap_size.y
	limit_left = used_rect.position.x * tilemap_size.x
	limit_right = (used_rect.position.x + used_rect.size.x) * tilemap_size.x

func _find_current_area():
	if not get_tree().get_first_node_in_group("camera_area"):
		return
		
	else:
		if not player:
			return
		
		var player_pos: Vector2 = player.global_position
		if current_area and current_area.contains_point(player_pos):
			return
		
		var tween = get_tree().create_tween()
		for area in all_areas:
			if area.contains_point(player_pos):
				tween.tween_property(self, "zoom", area.camera_zoom, 1.0)
