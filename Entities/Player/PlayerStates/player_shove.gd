class_name PlayerShove extends State


var player: Player

func enter():
	player = state_machine.get_parent()
	InteractionManager.can_interact = false
	
	player.force_meter.value = 0
	player.force_meter.show()
	player.set_collision_layer_value(4, false)
	player.animation_player.play("shove_charge")

func update(delta: float):
	pass

func physics_update(delta: float):
	player.handle_sprt_dir(true)
	player.force_meter.value += 1

	if Input.is_action_just_released("_shove"):
		player.animation_player.play("shove_release")
		player.force_meter.hide()
		
		var collided_obj: DynamicObject = player.handle_raycast_collision()
		if collided_obj:
			player.applied_force = player.force_meter.value * 4
			player.force_dir = player.mouse_dir
			
			collided_obj.apply_central_impulse(player.mouse_dir * (player.applied_force))
			
			player.set_collision_layer_value(4, true)
			player.force_meter.value = 0
			
			state_machine.change_state("playerknockback")
			
		await player.animation_player.animation_finished
		
		if player.velocity == Vector2.ZERO:
			state_machine.change_state("playeridle")
		else:
			state_machine.change_state("playerwalk")

func handle_input(event: InputEvent):
	pass

func exit():
	InteractionManager.can_interact = true
	player.force_meter.hide()
