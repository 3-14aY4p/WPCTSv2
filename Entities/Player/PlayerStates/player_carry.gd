class_name PlayerCarry extends State


var player: Player

func enter():
	player = state_machine.get_parent()
	InteractionManager.can_interact = false
	
	player.grabbed_obj.set_collision_layer_value(3, false)
	player.grabbed_obj.reparent(player.carry_position)

func update(delta: float):
	pass

func physics_update(delta: float):
	player.grabbed_obj.global_position = player.carry_position.global_position
	
	var speed_modifier = player.grabbed_obj.mass/2
	if speed_modifier < 2:
		speed_modifier = 2
	
	player.handle_movement(player.DEFAULT_SPEED/speed_modifier)
	player.handle_sprt_dir(true)
	
	if player.velocity == Vector2.ZERO:
		player.animation_player.play("carry_idle")
	else:
		player.animation_player.play("carry_walk")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("_drop"):
		var col: CarrierObject = player.handle_raycast_collision()
		if player.ray_cast_2d.is_colliding():
			if col.is_in_group("carrier_object") and col.carried_obj == null:
				player.grabbed_obj.reparent(col.marker_2d)
				col.carried_obj = player.grabbed_obj
				col.carried_obj.z_as_relative = false
				player.grabbed_obj = null
				
				state_machine.change_state("playeridle")
		else:
			player.grabbed_obj.reparent(get_tree().get_first_node_in_group("object_container"))
			player.grabbed_obj.global_position = player.aim_position.global_position
			player.grabbed_obj.set_collision_layer_value(3, true)
			player.grabbed_obj = null
			
			state_machine.change_state("playeridle")

func exit():
	InteractionManager.can_interact = true
