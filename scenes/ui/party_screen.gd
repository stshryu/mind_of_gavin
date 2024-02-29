extends Node2D

@onready var scene_root = $"."

var scene_manager: Node2D

var is_active_screen = false

signal active_main_menu

func _ready():
	active_main_menu.connect(get_parent().active_main_menu)
	scene_root.visible = false
	scene_manager = Utils.get_scene_manager()

func _on_menu_active_party_menu():
	is_active_screen = true
	scene_root.visible = true
	
func open_main_menu():
	is_active_screen = false
	active_main_menu.emit()
	scene_root.visible = false

func _unhandled_input(event):
	if !is_active_screen:
		return
	if event.is_action_pressed("back"):
		open_main_menu()
