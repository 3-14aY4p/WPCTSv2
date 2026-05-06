@tool
class_name ToggleableDoor extends InteractableObject


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var locked: bool = false
@export var opened: bool = true

func _physics_process(delta: float) -> void:
	handle_toggle()

func _on_interactable_area_interact() -> void:
	if locked:
		super._on_interactable_area_interact()
	else:
		if not opened:
			opened = true
		else:
			opened = false

func handle_toggle():
	if opened:
		collision_shape_2d.disabled = true
		animated_sprite_2d.play("open")
	else:
		collision_shape_2d.disabled = false
		animated_sprite_2d.play("close")
