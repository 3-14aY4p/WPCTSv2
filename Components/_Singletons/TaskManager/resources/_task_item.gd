class_name TaskItem extends Resource

@export var title: String
@export_multiline() var description: String
@export var task_id: String
@export_range(1, 300, 0.5) var time: float

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

func passed_task():
	if task_status == TaskStatus.STARTED:
		task_status = TaskStatus.PASSED

func failed_task():
	if task_status == TaskStatus.STARTED:
		task_status = TaskStatus.FAILED

func finish_task():
	if task_status == TaskStatus.PASSED:
		task_status = TaskStatus.FINISHED
