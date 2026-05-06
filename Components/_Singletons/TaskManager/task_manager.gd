extends Node
# this is a global node

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var target_container = get_tree().get_nodes_in_group("target_area")

@onready var task_interface: Control = $CanvasLayer/TaskInterface
@onready var task_details: Control = $CanvasLayer/TaskInterface/TaskDetails
@onready var task_hud: Control = $CanvasLayer/TaskInterface/TaskHUD

@export var current_task: TaskItem
@export var next_task: TaskItem
var task_cache: Dictionary = {}

func _ready() -> void:
	task_interface.hide()

func _process(delta: float) -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")
		
	var tween = get_tree().create_tween()
	if Input.is_action_pressed("_task_details"):
		tween.tween_property(task_interface, "position", Vector2(416, 0), .5)
	else:
		tween.tween_property(task_interface, "position", Vector2(0, 0), .5)

func load_task():
	if task_cache.has(next_task):
		current_task = task_cache[next_task]
	else:
		current_task = next_task
	next_task = null

func task_start():
	current_task.start_task()
	task_interface.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		current_task = null
		task_interface.hide()
