class_name NPC extends CharacterBody2D


@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var interactable_area: InteractableArea = $InteractableArea

@export var action_hint: String = "[E] talk"
@export var assigned_task: TaskItem
@export var can_talk: bool = true
@export_file("*.json") var dialogue_files: PackedStringArray
var dialogue_index: int = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if can_talk:
		action_hint = ""
	else:
		action_hint = "[E] talk"

func _on_interactable_area_interact() -> void:
	if not dialogue_files.is_empty() and can_talk:
		if assigned_task:
			TaskManager.next_task = assigned_task
			
		DialogueManager.activate_dialogue(dialogue_files[dialogue_index])

func _on_interactable_area_interaction_available():
	pass

func _on_interactable_area_interaction_unavailable() -> void:
	pass
