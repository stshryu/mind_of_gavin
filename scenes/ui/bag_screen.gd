extends Node2D

@onready var select_point = $Control/SelectPoint
@onready var scene_parent = $"."

@export var init_x = 43
@export var offset_x = 8

enum BAGSCREEN { KEY, ITEM, TMHM, BERRIES, BALLS }
var current_screen = BAGSCREEN.KEY
var selected_option: int = 0
var scene_manager: Node2D

var is_active_screen = false

signal active_main_menu

func _ready():
	active_main_menu.connect(get_parent().active_main_menu)
	scene_parent.visible = false
	scene_manager = Utils.get_scene_manager()
	select_point.position.y = init_x + (selected_option % len(BAGSCREEN)) * offset_x

func _on_menu_active_bag_menu():
	is_active_screen = true
	scene_parent.visible = true

func open_main_menu():
	is_active_screen = false
	active_main_menu.emit()
	scene_parent.visible = false

func _unhandled_input(event):
	if !is_active_screen:
		return
	print('bag is active')
	if event.is_action_pressed("back"):
		open_main_menu()
			
