extends Node
# this is a global node

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var target_container = get_tree().get_nodes_in_group("target_area")

@export var current_task: TaskItem

func _process(delta: float) -> void:
	if current_task:
		pass
