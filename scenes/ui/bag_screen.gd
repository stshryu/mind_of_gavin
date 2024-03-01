extends Node2D

@onready var select_point = $Control/SelectPoint
@onready var bag_option_root = $Control/OptionsContainer
@onready var animation_player = $Control/AnimationPlayer
@onready var scene_root = $"."

@export var init_x = 43
@export var offset_x = 8

enum BAGSCREEN { KEY, ITEM, TMHM, BERRIES, BALLS }
var selected_option: int
var scene_manager: Node2D
var bag_options: Array
var bag_opt_length: int
var player_inventory: PlayerInventory

var is_active_screen = false

signal active_main_menu

func _ready():
	active_main_menu.connect(get_parent().active_main_menu)
	scene_root.visible = false
	scene_manager = Utils.get_scene_manager()
	bag_options = bag_option_root.get_children()
	bag_opt_length = bag_options.size()
	selected_option = 0

func _on_menu_active_bag_menu():
	player_inventory = Utils.get_player_inventory()
	var key_items = player_inventory.inventory["KeyItems"]
	for item in key_items:
		print(item.name)
	is_active_screen = true
	scene_root.visible = true
	set_active_bag_option()

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
	animation_player.play(active_option.name)
	
# This bit of code below is "supposed" to create an animation through code so you don't have to animate
# each individual bag sprite. Can't get it to work though, the documentation surrounding the AnimationPlayer
# is too vague to really piece together what you need to write animations through code. Maybe its something
# to revisit later when we have time to really explore the engine code.

#func _create_bag_shake():
	#var anim_lib = AnimationLibrary.new()
	#for option in bag_options:
		#var animation = Animation.new()
		#animation.step = 0.1
		#animation.length = 0.2
#
		#var texture = option.find_children("Bag").back()
		#var sprite_path: NodePath = scene_root.get_path_to(texture)
		#
		#var sprite_vis_path: NodePath = "%s:visible" % sprite_path
		#var vis_track_index = animation.add_track(Animation.TYPE_VALUE)
		#animation.track_set_path(vis_track_index, sprite_vis_path)
		#animation.track_insert_key(vis_track_index, 0.0, true)
		#
		#var sprite_texture_path: NodePath = "%s:texture" % sprite_path
		#var texture_track_index = animation.add_track(Animation.TYPE_VALUE)
		#animation.track_set_path(texture_track_index, sprite_texture_path)
		#animation.track_insert_key(texture_track_index, 0.0, texture)
		#
		#var sprite_rotation_path: NodePath = "%s:rotation" % sprite_path
		#var rota_track_index = animation.add_track(Animation.TYPE_VALUE)
		#animation.track_set_path(rota_track_index, sprite_rotation_path)
		#animation.track_insert_key(rota_track_index, 0.0, 4)
		#animation.track_insert_key(rota_track_index, 0.2, 0)
		#
		#anim_lib.add_animation(option.name, animation)
	#animation_player.add_animation_library("bag_anim", anim_lib)
