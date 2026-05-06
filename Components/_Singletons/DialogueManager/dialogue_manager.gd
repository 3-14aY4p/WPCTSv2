extends Node
# this is a global node

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if not player:
		player = get_tree().get_first_node_in_group("player")

func activate_dialogue(dialogue_file):
	player.state_machine.change_state("playerdisabled")
	
	var dialogue_instance: DialogueInstance = preload("uid://c1g30yjbrt5um").instantiate()
	dialogue_instance.dialogue_file = dialogue_file
	
	add_child(dialogue_instance)

func activate_line(name: String, anim: String, text: String):
	player.state_machine.change_state("playerdisabled")
	
	var dialogue_instance: DialogueInstance = preload("uid://c1g30yjbrt5um").instantiate()
	add_child(dialogue_instance)
	
	dialogue_instance.load_dialogue(name, anim, text)
	
