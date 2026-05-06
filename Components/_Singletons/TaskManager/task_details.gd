extends Control


@onready var title_label: Label = %TitleLabel
@onready var details_label: RichTextLabel = %DetailsLabel
@onready var time_label: RichTextLabel = %TimeLabel
@onready var goal_label: RichTextLabel = %GoalLabel

func _process(delta: float) -> void:
	var task: TaskItem = TaskManager.current_task
	if task and task.task_status == TaskItem.TaskStatus.STARTED:
		title_label.text = task.title 
		details_label.text = task.description 
		
		if task.time_limit == -1:
			time_label.text = "N/A"
		else:
			var min: int = task.timer.time_left/60
			var sec: int = fmod(task.timer.time_left, 60)
			if sec >= 10:
				time_label.text = "%d:%d" % [min, sec]
			else:
				time_label.text = "%d:0%d" % [min, sec]
		#goal_label.text = "%d out of %d" % [TaskManager.cleared_areas.size(), TaskManager.target_areas.size()]
