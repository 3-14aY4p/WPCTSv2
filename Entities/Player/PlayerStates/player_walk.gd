class_name PlayerWalk extends State


var player: Player

func enter():
	player = state_machine.get_parent()

func update(delta: float):
	pass

func physics_update(delta: float):
	player.handle_sprt_dir(true)
	player.handle_movement()
	player.animation_player.play("walk")
	
	if player.velocity == Vector2.ZERO:
		state_machine.change_state("playeridle")

func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("_shove"):
		state_machine.change_state("playershove")
	
	elif Input.is_action_just_pressed("_grab"):
		var object: DynamicObject = player.handle_raycast_collision()
		if object and object.is_in_group("pickable_object"):
			player.grabbed_obj = object
			state_machine.change_state("playercarry")

		elif object and object.is_in_group("carrier_object"):
			if object.carried_obj:
				object.carried_obj.z_as_relative = true
				player.grabbed_obj = object.carried_obj
				object.carried_obj = null
				state_machine.change_state("playercarry")

func exit():
	pass
