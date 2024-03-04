extends Node2D

@onready var select_point = $Control/SelectPoint
@onready var bag_option_root = $Control/OptionsContainer
@onready var animation_player = $Control/AnimationPlayer
@onready var scene_root = $"."
@onready var bag_selections_container = $Control/MarginContainer/ContainerLayout
@onready var bag_selection_desc = $Control/ItemDesc
@onready var bag_selection_sprite = $Control/ItemSprite
@onready var bag_select_arrow = $Control/ItemSelect

@export var init_x = 43
@export var offset_x = 8

var bag_unit_scene = preload("res://scenes/ui/bag_item_unit.tscn")
var selected_option: int
var selected_item: int
var scene_manager: Node2D
var bag_options: Array
var bag_opt_length: int
var player_inventory: PlayerInventory
var bag_unit_selection_hash = { "KeyItems": 0, "Items": 0, "Berries": 0, "Balls": 0, "TMHM": 0}
var select_sprite_y_init: int = 18
var select_sprite_y_offset: int = 15

var is_active_screen = false

signal active_main_menu

func _ready():
	scene_root.visible = false
	active_main_menu.connect(get_parent().active_main_menu)
	scene_manager = Utils.get_scene_manager()
	player_inventory = Utils.get_player_inventory()
	bag_options = bag_option_root.get_children()
	bag_opt_length = bag_options.size()
	selected_option = 0
	selected_item = 0
	
	# For testing
	_testing()

func _on_menu_active_bag_menu():
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
		selected_item = 0
		selected_option = bag_opt_length - 1 if selected_option == 0 else selected_option - 1
		set_active_bag_option()
	elif event.is_action_pressed("ui_right"):
		selected_item = 0
		selected_option += 1
		set_active_bag_option()
	elif event.is_action_pressed("ui_down"):
		selected_item += 1
		bag_select_arrow.position.y += select_sprite_y_offset
	elif event.is_action_pressed("ui_up"):
		selected_item = 0 if selected_item == 0 else selected_item - 1
		bag_select_arrow.position.y = select_sprite_y_init if selected_item == 0 \
			else bag_select_arrow.position.y - select_sprite_y_offset

func set_active_bag_option():
	var active_option = bag_options[selected_option % bag_opt_length]
	select_point.position.x = init_x + (selected_option % bag_opt_length) * offset_x
	for option in bag_options:
		option.visible = true if option.name == active_option.name else false
	_depopulate_container()
	_populate_active_option(active_option)
	animation_player.play(active_option.name)
	
func _depopulate_container() -> void:
	for n in bag_selections_container.get_children():
		bag_selections_container.remove_child(n)
		n.queue_free()
	
func _populate_active_option(active_option: Object) -> void:
	var current_items = player_inventory.inventory[active_option.name]
	for item in current_items:
		var instance = bag_unit_scene.instantiate()
		bag_selections_container.add_child(_populate_option_field(instance, item))
	
func _populate_option_field(_inst, _opt):
	var textroot = _inst.find_child("Unit")
	textroot.find_child("Name").text = _opt.name
	textroot.find_child("Quantity").text = "[right]" + "x" + str(_opt.quantity) + "[/right]"
	return _inst
	
func _testing() -> void:
	var rng = RandomNumberGenerator.new()
	var test = [ "KeyItems", "Items", "TMHM", "Berries", "Balls" ]
	for key in test:
		for i in range(1, rng.randi_range(2, 10)):
			var item = ItemDict.loaded_items["KeyItems"]["egg"].duplicate()
			item.quantity = rng.randi_range(1, 99)
			player_inventory.inventory[key].append(item)

# This bit of code below is "supposed" to create an animation through code so you don't have to animate
# each individual bag sprite. Can't get it to work though, the documentation surrounding the AnimationPlayer
# is too vague to really piece together what you need to write animations through code. Maybe its something
# to revisit later when we have time to really explore the engine code.
# 
# Maybe consider using Tweens? Might be useful.

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
