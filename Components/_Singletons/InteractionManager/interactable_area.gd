class_name InteractableArea extends Area2D


signal interaction_available
signal interaction_unavailable
signal interact

@export var interaction_input: String = "_interact"

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	if event.is_action_pressed(interaction_input):
		if not InteractionManager.active_areas.is_empty():
			if InteractionManager.can_interact and InteractionManager.nearest == self:
				InteractionManager.can_interact = false
				InteractionManager.label.hide()
				
				interact.emit()
				
				InteractionManager.can_interact = true

#func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#set_process_unhandled_input(true)
		#InteractionManager.active_areas.push_back(self)
		#
		#interaction_available.emit()
#
#func _on_body_exited(body: Node2D) -> void:
	#if body.is_in_group("player"):
		#set_process_unhandled_input(false)
		#InteractionManager.active_areas.erase(self)
		#
		#interaction_unavailable.emit()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "InteractionPointer":
		set_process_unhandled_input(true)
		InteractionManager.active_areas.push_back(self)
		
		interaction_available.emit()

func _on_area_exited(area: Area2D) -> void:
	if area.name == "InteractionPointer":
		set_process_unhandled_input(false)
		InteractionManager.active_areas.erase(self)
		
		interaction_unavailable.emit()
