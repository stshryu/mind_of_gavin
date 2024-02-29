extends Node2D

@onready var select_point = $Control/SelectPoint
@onready var bag_option_root = $Control/OptionsContainer
@onready var scene_root = $"."

@export var init_x = 43
@export var offset_x = 8

enum BAGSCREEN { KEY, ITEM, TMHM, BERRIES, BALLS }
var selected_option: int
var scene_manager: Node2D
var bag_options: Array
var bag_opt_length: int

var is_active_screen = false

signal active_main_menu

func _ready():
	active_main_menu.connect(get_parent().active_main_menu)
	scene_root.visible = false
	scene_manager = Utils.get_scene_manager()
	bag_options = bag_option_root.get_children()
	bag_opt_length = bag_options.size()
	selected_option = 0
	set_active_bag_option()

func _on_menu_active_bag_menu():
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
	elif event.is_action_pressed("ui_left"):
		selected_option = bag_opt_length - 1 if selected_option == 0 else selected_option - 1
		set_active_bag_option()
	elif event.is_action_pressed("ui_right"):
		selected_option += 1
		set_active_bag_option()

func set_active_bag_option():
	var active_option = bag_options[selected_option % bag_opt_length]
	select_point.position.x = init_x + (selected_option % bag_opt_length) * offset_x

	for option in bag_options:
		option.visible = true if option.name == active_option.name else false
