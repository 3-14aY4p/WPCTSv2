class_name TaskItem extends Resource

@export var task_id: String
@export var title: String
@export_multiline() var description: String

@export_range(-1, 300, 1) var time_limit: int = -1
var timer

enum TaskStatus {
	AVAILABLE,
	STARTED,
	PASSED,
	FAILED,
	FINISHED,
}
@export var task_status: TaskStatus 

func start_task():
	if task_status == TaskStatus.AVAILABLE:
		task_status = TaskStatus.STARTED
		
		timer = Timer.new()
		TaskManager.add_child(timer)
		
		if time_limit != -1:
			timer.autostart = false
			timer.start(time_limit)

func passed_task():
	if task_status == TaskStatus.STARTED:
		task_status = TaskStatus.PASSED

func failed_task():
	if task_status == TaskStatus.STARTED:
		task_status = TaskStatus.FAILED

func finish_task():
	if task_status == TaskStatus.PASSED:
		task_status = TaskStatus.FINISHED
