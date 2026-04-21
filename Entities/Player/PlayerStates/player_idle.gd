class_name PlayerIdle extends State


var player: Player

func enter():
	player = state_machine.get_parent()

func update(delta: float):
	pass

func physics_update(delta: float):
	player.handle_sprt_dir(true)
	player.animation_player.play('idle')
	
func handle_input(event: InputEvent):
	if Input.is_action_just_pressed("_up") or Input.is_action_just_pressed("_down") or Input.is_action_just_pressed("_left") or Input.is_action_just_pressed("_right"):
		state_machine.change_state("playerwalk")
	
	elif Input.is_action_just_pressed("_shove"):
		state_machine.change_state("playershove")
	
	elif Input.is_action_just_pressed("_grab"):
		pass

func exit():
	pass
