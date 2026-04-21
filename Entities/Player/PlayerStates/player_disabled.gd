class_name PlayerDisabled extends State


var player: Player

func enter():
	player = state_machine.get_parent()
	player.animation_player.play("idle")

func update(delta: float):
	InteractionManager.can_interact = false
	InteractionManager.label.hide()

func physics_update(delta: float):
	pass

func handle_input(event: InputEvent):
	pass

func exit():
	InteractionManager.can_interact = true
