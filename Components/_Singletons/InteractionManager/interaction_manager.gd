extends Node
# this is a global node

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var label: Label = $Label

var active_areas: Array[InteractableArea]
var can_interact: bool = true
var nearest: InteractableArea

func _process(delta: float) -> void:
	active_areas = active_areas.filter(func(a): return is_instance_valid(a))
	
	if not active_areas.is_empty() and can_interact:
		active_areas.sort_custom(sort_by_distance_to_player)
		nearest = active_areas[0]
		
		label.text = nearest.get_parent().action_hint
		label.global_position = nearest.global_position
		label.global_position.y -= 32
		label.global_position.x -= label.size.x / 2
		label.show()
		
	else:
		label.hide()

func sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.direction_to(area1.global_position)
	var area2_to_player = player.global_position.direction_to(area2.global_position)
	return area1_to_player < area2_to_player
