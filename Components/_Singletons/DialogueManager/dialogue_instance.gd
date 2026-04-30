class_name DialogueInstance extends Control


@onready var player: Player = get_tree().get_first_node_in_group("player")

@onready var portrait_container: Control = %PortraitContainer
@onready var character_name: Label = %CharacterName
@onready var character_portrait: AnimatedSprite2D = %CharacterPortrait

@onready var dialogue_label: RichTextLabel = %DialogueLabel
@onready var button_container: GridContainer = %ButtonContainer
@onready var indicator: AnimatedSprite2D = %IndicatorSprite

@export_file("*.json") var dialogue_file
var scene_script: Dictionary
var curr_block: Dictionary
var next_block: Dictionary
var await_choice: bool = false

func _ready() -> void:
	visible = false
	button_container.hide()
	indicator.hide()
	
	scene_script = get_json(dialogue_file)
	
	# for testing
	load_block(scene_script["dialogue_line"])

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_next_line") and not await_choice:
		next()
	elif event.is_action_pressed("_skip_line") and not await_choice:
		skip()

func get_json(src: String) -> Dictionary:
	var json_text: String = FileAccess.get_file_as_string(src)
	var json_dict: Dictionary = JSON.parse_string(json_text)
	return json_dict

# update GUI
func load_block(block: Dictionary):
	# no name to display if no portrait to display
	if block.has("anim") and block["anim"] != "": 
		portrait_container.show()
		character_portrait.play(block["anim"])
		if block.has("name") and block["name"] != "": 
			character_name.show()
			character_name.text = block["name"]
		else:
			character_name.hide()
		dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else:
		portrait_container.hide()
		character_name.hide()
		dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
	if block.has("text"): 
		dialogue_label.text = block["text"]
		
	# check if it's line, choice, or func, or if it's the last item
	if block.has("next"):
		button_container.hide()
		await_choice = false
		var key = block["next"]
		next_block = scene_script[key]
		
	elif block.has("choices"):
		button_container.show()
		await_choice = true
		var choices: Array = block["choices"].keys()
		var paths: Array = block["choices"].values()
		
		if choices.size() > 1:
			button_container.columns = 2
		else:
			button_container.columns = 1
			
		for i in choices.size():
			var button_instance: Button = preload("uid://cc70oile13cbd").instantiate()
			button_instance.text = choices[i]
			button_instance.connect("pressed", on_choice_pressed.bind(paths[i]))
			button_container.add_child(button_instance)
			
	elif block.has("func"):
		button_container.hide()
		await_choice = false
		
	else:
		# print error and stops runtime
		assert(false, "INVALID BLOCK.")

func on_choice_pressed(path: String):
	button_container.hide()
	for b in button_container.get_children():
		b.queue_free()
		
	next_block = scene_script[path]
	next()

func next():
	if next_block:
		curr_block = next_block
		load_block(curr_block)
	else:
		#player.state_machine.change_state("playeridle")
		queue_free()

func skip():
	pass
