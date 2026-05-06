# add to GLOBAL SCRIPT
class_name GameManager extends Node

@export var world_2d: Node2D
@export var ui: Control
@export var curr_2d_scene: Node2D
@export var curr_ui_scene: Control

var scene_cache: Dictionary = {} # Store loaded scenes by path
enum SwitchMode {
	DELETE, ## Delete from memory
	HIDE, ## Hide from scene tree
	REMOVE, ## Remove from scene tree
}

func _ready() -> void:
	Global.game_manager = self

func remove_ui_scene(mode: SwitchMode):
	match mode:
		SwitchMode.DELETE:
			curr_ui_scene.queue_free()
		SwitchMode.HIDE:
			curr_ui_scene.hide()
		SwitchMode.REMOVE:
			ui.call_deferred("remove_child", curr_ui_scene)

func remove_2d_scene(mode: SwitchMode):
	match mode:
		SwitchMode.DELETE:
			curr_2d_scene.queue_free()
		SwitchMode.HIDE:
			curr_2d_scene.hide()
		SwitchMode.REMOVE:
			ui.call_deferred("remove_child", curr_2d_scene)

func change_ui_scene(new_scene: String, mode: SwitchMode):
	if curr_ui_scene:
		match mode:
			SwitchMode.DELETE:
				var scene_path := curr_ui_scene.scene_file_path
				curr_ui_scene.queue_free()
				scene_cache.erase(scene_path)
				
			SwitchMode.HIDE:
				curr_ui_scene.hide()
				
			SwitchMode.REMOVE:
				ui.call_deferred("remove_child", curr_ui_scene)
				
	var new_node: Node
	#if scene_cache.has(new_scene):
		#new_node = scene_cache[new_scene]
		#if new_node.get_parent() == null:
			#ui.call_deferred("add_child", new_node)
		#new_node.show()
	#else:
	new_node = load(new_scene).instantiate()
	scene_cache[new_scene] = new_node
	ui.call_deferred("add_child", new_node)
		
	set_deferred("curr_ui_scene", new_node)

func change_2d_scene(new_scene: String, mode: SwitchMode):
	if curr_2d_scene:
		match mode:
			SwitchMode.DELETE:
				var scene_path := curr_2d_scene.scene_file_path
				curr_2d_scene.queue_free()
				scene_cache.erase(scene_path)
				
			SwitchMode.HIDE:
				curr_2d_scene.hide()
				
			SwitchMode.REMOVE:
				world_2d.call_deferred("remove_child", curr_2d_scene)
				
	var new_node: Node
	#if scene_cache.has(new_scene):
		#new_node = scene_cache[new_scene]
		#if new_node.get_parent() == null:
			#world_2d.call_deferred("add_child", new_node)
		#new_node.show()
	#else:
	new_node = load(new_scene).instantiate()
	scene_cache[new_scene] = new_node
	world_2d.call_deferred("add_child", new_node)
		
	set_deferred("curr_2d_scene", new_node)
