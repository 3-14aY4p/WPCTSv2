class_name TargetArea extends Area2D


var detected_objects: Array[DynamicObject] = []
var area_clear: bool = false
var task: PlacementTask

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if TaskManager.current_task is PlacementTask:
		task = TaskManager.current_task
		
	if detected_objects.size() < task.objects_per_area:
		area_clear = false
	else:
		area_clear = true

func _on_body_entered(body: Node2D) -> void:
	if body.task_object:
		detected_objects.append(body)
		task.objects_in_area.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.task_object:
		detected_objects.erase(body)
		task.objects_in_area.erase(body)
