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
		pass

func exit():
	pass
