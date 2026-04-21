class_name PlayerCarry extends State


var player: Player

func enter():
	player = state_machine.get_parent()

func update(delta: float):
	pass

func physics_update(delta: float):
	pass

func handle_input(event: InputEvent):
	pass

func exit():
	pass
