class_name PlayerKnockback extends State


var player: Player

func enter():
	player = state_machine.get_parent()
	player.handle_knockback(-player.force_dir, player.applied_force/1.5)
	InteractionManager.can_interact = false

func update(delta: float):
	pass

func physics_update(delta: float):
	player.animation_player.play("knockback")
	
	player.knockback_velocity = player.knockback_velocity.lerp(Vector2.ZERO, player.knockback_decay * delta)
	
	player.velocity = player.knockback_velocity
	player.move_and_slide()
	
	if player.knockback_velocity.length() < player.knockback_min_threshold:
		state_machine.change_state("playeridle")

func handle_input(event: InputEvent):
	pass

func exit():
	InteractionManager.can_interact = true
