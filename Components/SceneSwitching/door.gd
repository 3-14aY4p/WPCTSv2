class_name Door extends Area2D


signal player_entered_door(door: Door, transition_type: String)

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var path_to_new_scene: String
@export var entry_point: String
@export var spawn_distance: int = 16
@export var locked: bool = false

# player's last direction, in short; where it opens to
@export_enum("North", "South", "East", "West") var entry_direction = "South"
@export_enum("fade_in", "fade_out") var transition_type = "fade_out"

func _ready() -> void:
	transition_type = transition_type

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
		
	if locked:
		pass
	else:
		player_entered_door.emit(self)
		Global.game_manager.change_2d_scene(path_to_new_scene, GameManager.SwitchMode.REMOVE)

func get_player_entry_vector():
	var vector: Vector2 = Vector2.LEFT
	match entry_direction:
		"North":
			vector = Vector2.UP
		"South":
			vector = Vector2.DOWN
		"East":
			vector = Vector2.RIGHT
			
	return (vector * spawn_distance)
