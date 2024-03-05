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
var bag_unit_selection_length: int
var player_inventory: PlayerInventory
var bag_unit_selection_hash = { "KeyItems": 0, "Items": 0, "Berries": 0, "Balls": 0, "TMHM": 0}
var select_sprite_y_init: int = 18
var select_sprite_y_offset: int = 15
var current_items: Array
var active_option: Object
var rng: RandomNumberGenerator

var is_active_screen = false

signal active_main_menu

func _ready():
	scene_root.visible = false
	active_main_menu.connect(get_parent().active_main_menu)
	scene_manager = Utils.get_scene_manager()
	player_inventory = Utils.get_player_inventory()
	bag_options = bag_option_root.get_children()
	bag_opt_length = bag_options.size()
	rng = RandomNumberGenerator.new()
	selected_option = 0
	selected_item = 0
	
	# For testing
	_testing()

func _on_menu_active_bag_menu():
	is_active_screen = true
	scene_root.visible = true
	set_active_bag_option()
	_display_selected_unit(selected_item)

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
		bag_select_arrow.position.y = select_sprite_y_init
		_display_selected_unit(selected_item)
	elif event.is_action_pressed("ui_right"):
		selected_item = 0
		selected_option += 1
		set_active_bag_option()
		bag_select_arrow.position.y = select_sprite_y_init
		_display_selected_unit(selected_item)
	elif event.is_action_pressed("ui_down"):
		if selected_item < bag_unit_selection_length - 1:
			selected_item += 1
			#animation_player.play(**{'name': active_option.name, 'custom_speed': 3.0})
			animation_player.play(active_option.name, -1.0, rng.randf_range(1.5, 3.0))
		bag_select_arrow.position.y = select_sprite_y_init + (selected_item % bag_unit_selection_length) \
			* select_sprite_y_offset
		_display_selected_unit(selected_item)
	elif event.is_action_pressed("ui_up"):
		if selected_item != 0:
			selected_item -= 1
			animation_player.play(active_option.name, -1.0, rng.randf_range(1.5, 3.0))
		bag_select_arrow.position.y = select_sprite_y_init + (selected_item % bag_unit_selection_length) \
			* select_sprite_y_offset
		_display_selected_unit(selected_item)

func set_active_bag_option():
	active_option = bag_options[selected_option % bag_opt_length]
	select_point.position.x = init_x + (selected_option % bag_opt_length) * offset_x
	for option in bag_options:
		option.visible = true if option.name == active_option.name else false
	_depopulate_container()
	_populate_active_option(active_option)
	animation_player.play(active_option.name)
	
func _display_selected_unit(selected_item) -> void:
	bag_selection_desc.text = current_items[selected_item].description
	bag_selection_sprite.texture = current_items[selected_item].texture
	
func _depopulate_container() -> void:
	for n in bag_selections_container.get_children():
		bag_selections_container.remove_child(n)
		n.queue_free()
	
func _populate_active_option(active_option: Object) -> void:
	current_items = player_inventory.inventory[active_option.name]
	bag_unit_selection_length = current_items.size()
	for item in current_items:
		var instance = bag_unit_scene.instantiate()
		bag_selections_container.add_child(_populate_option_field(instance, item))
	
func _populate_option_field(_inst, _opt):
	var textroot = _inst.find_child("Unit")
	textroot.find_child("Name").text = _opt.name
	textroot.find_child("Quantity").text = "[right]" + "x" + str(_opt.quantity) + "[/right]"
	return _inst
	
func _testing() -> void:
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
