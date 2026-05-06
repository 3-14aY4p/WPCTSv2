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
	
	# initialize the script
	if dialogue_file:
		scene_script = get_json(dialogue_file)
		load_block(scene_script["0"])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("_next_line") and not await_choice:
		next()

# manually load dialogue
func load_dialogue(name: String, anim: String, text: String):
	if anim != "":
		portrait_container.show()
		character_portrait.play(anim)
		if name != "":
			character_name.show()
			character_name.text = name
		else: character_name.hide()
		dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else: 
		portrait_container.hide()
		character_name.hide()
		dialogue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialogue_label.text = text

# convert json to dictionary
func get_json(src: String):
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
		else: character_name.hide()
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
		indicator.show()
		await_choice = false
		
		if block["next"] != "":
			var key = block["next"]
			next_block = scene_script[key]
		else:
			next_block = {}
		
	elif block.has("choices"):
		button_container.show()
		indicator.hide()
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
		indicator.hide()
		await_choice = false
		
		if block["hide_box"]:
			visible = false
		
		var target_node = get_node(block["node"])
		var func_name = block["func"]
		
		# Since we can't directly put the properties in the
		# json file itself, we can just retrieve them here
		var raw_args = block["args"]	# String values
		var func_args = []
		
		# convert string values to property
		if raw_args:
			for arg in raw_args:
				func_args.append(get(arg))
		
		if target_node.has_method(func_name):
			if func_args.is_empty():
				target_node.call(func_name)
			else:
				target_node.callv(func_name, func_args)
				
		if block["await"]:
			var signal_name = block["await"]
			if target_node.has_signal(signal_name):
				var signal_state = {"done": false} # dict because lambda functions
				var callable = func(_args): signal_state.done = true
				target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
				while not signal_state.done:
					await get_tree().process_frame
					
		if block["comment"] != "":
			var key = block["comment"]
			next_block = scene_script[key]
		else:
			next_block = {}
		next()
		
	else:
		assert(false, "Err: INVALID BLOCK.")

func on_choice_pressed(path: String):
	button_container.hide()
	for b in button_container.get_children():
		b.queue_free()
		
	if path != "":
		next_block = scene_script[path]
	else:
		next_block = {}
	next()

func next():
	if next_block != {}:
		curr_block = next_block
		load_block(curr_block)
	else:
		player.state_machine.change_state("playeridle")
		queue_free()
