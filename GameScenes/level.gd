class_name Level extends Node2D


@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var door_container = get_tree().get_nodes_in_group("door")

func _ready() -> void:
	add_to_group("game_scene")
	
	player.state_machine.change_state("playerdisabled")
	player.visible = false
	
	enter_level()

func enter_level():
	_connect_to_door()
	
	if Global.last_entry_point and Global.last_entry_direction:
		init_player_position()
		player.visible = true
	else:
		player.visible = true
	
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.start(1.5)
		
		await timer.timeout
		timer.queue_free()
		
		player.state_machine.change_state("playeridle")
	

func init_player_position():
	var tween = get_tree().create_tween()
	
	for door in door_container:
		if door.name == Global.last_entry_point:
			#player.global_position = door.global_position + Global.last_entry_direction
			player.global_position = door.global_position + (Global.last_entry_direction/2.5)
			player.animation_player.play("walk")
			tween.tween_property(player, "global_position", door.global_position + Global.last_entry_direction, 0.5)
			
			await tween.finished
			player.state_machine.change_state("playeridle")

# is connected to door.player_entered_door signal
func _on_player_entered_door(door: Door):
	_disconnect_from_door()
	
	player.state_machine.change_state("playerdisabled")
	player.camera_2d.reparent(self)
	
	player.queue_free()
	
	Global.last_entry_direction = door.get_player_entry_vector()
	Global.last_entry_point = door.entry_point

func _connect_to_door():
	for door in door_container:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)

func _disconnect_from_door():
	for door in door_container:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)
