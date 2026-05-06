class_name DynamicObject extends RigidBody2D


@export_range(1.0, 400.0, 0.5) var minimum_force: float ## Minimum force required to move object.
@export var disabled: bool = false						## Triggers sleeping.
@export var task_object: bool = false					## Is the object part of a task?

func _ready() -> void:
	if task_object:
		add_to_group("task_object")

func _physics_process(delta: float) -> void:
	if disabled:
		sleeping = true

func apply_shove(mouse_dir: Vector2, applied_force: float):
	if applied_force >= minimum_force and not disabled:
		apply_central_impulse(mouse_dir * (applied_force))
