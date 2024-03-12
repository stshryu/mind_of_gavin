extends CanvasLayer

@onready var select_arrow = $Control/NinePatchRect/SelectArrow
@onready var menu = $Control
@onready var vboxcontainer = $Control/NinePatchRect/VBoxContainer
@onready var partyscreen = $PartyScreen
@onready var bagscreen = $BagScreen

@export var init_y: int = 7
@export var offset_y: int = 16

var scene_manager: Node2D
enum CURRENTSCREEN { NOTHING, MENU, PARTY, BAG, PLAYER, OPTION }
var current_screen = CURRENTSCREEN.NOTHING
var selected_option: int = 0
var menu_options: Array
var menu_opt_length: int 
var player: Object

var is_active_screen = true

signal active_bag_menu
signal active_party_menu
signal active_player_menu
signal active_option_menu

func _ready():
	scene_manager = Utils.get_scene_manager()
	menu_options = vboxcontainer.get_children()
	menu_opt_length = menu_options.size()
	menu.visible = false
	partyscreen.visible = false
	bagscreen.visible = false
	select_arrow.position.y = init_y + (selected_option % menu_opt_length) * offset_y
	
func _unhandled_input(event):
	if !is_active_screen:
		return
	player = Utils.get_player()
	match current_screen:
		CURRENTSCREEN.NOTHING:
			if event.is_action_pressed("menu"):
				if not player.is_moving:
					menu.visible = true
					current_screen = CURRENTSCREEN.MENU
					player.can_act = false
		CURRENTSCREEN.MENU:
			if event.is_action_pressed("menu") or event.is_action_pressed("back"):
				menu.visible = false
				current_screen = CURRENTSCREEN.NOTHING
				player.can_act = true
			elif event.is_action_pressed("select"):
				_menu_options()
			elif event.is_action_pressed("ui_down"):
				selected_option += 1
				select_arrow.position.y = init_y + (selected_option % menu_opt_length) * offset_y
			elif event.is_action_pressed("ui_up"):
				selected_option = menu_opt_length - 1 if selected_option == 0 else selected_option - 1
				select_arrow.position.y = init_y + (selected_option % menu_opt_length) * offset_y
		CURRENTSCREEN.PARTY, CURRENTSCREEN.BAG, CURRENTSCREEN.PLAYER, CURRENTSCREEN.OPTION:
			if event.is_action_pressed("back"):
				menu.visible = true
				current_screen = CURRENTSCREEN.MENU

func active_main_menu() -> void:
	is_active_screen = true
	menu.visible = true

func open_screen(screen: CURRENTSCREEN) -> void:
	is_active_screen = false
	match screen:
		CURRENTSCREEN.PARTY:
			current_screen = CURRENTSCREEN.PARTY
			active_party_menu.emit()
		CURRENTSCREEN.BAG:
			current_screen = CURRENTSCREEN.BAG
			active_bag_menu.emit()
		CURRENTSCREEN.PLAYER:
			current_screen = CURRENTSCREEN.PLAYER
			active_player_menu.emit()
		CURRENTSCREEN.OPTION:
			current_screen = CURRENTSCREEN.OPTION
			active_option_menu.emit()
	menu.visible = false
	
func _menu_options() -> void:
	var current_selection = menu_options[selected_option % menu_opt_length]
	match current_selection.name:
		"Pokemon":
			open_screen(CURRENTSCREEN.PARTY)
		"Bag":
			open_screen(CURRENTSCREEN.BAG)
		"Player":
			print_debug("player")
		"Options":
			print_debug("options")
		"Save":
			var savedata = SaveData.new()
			var packedscene = PackedScene.new()
			packedscene.pack(Utils.get_scene_manager().find_child("CurrentScene").duplicate())
			savedata.current_scene = packedscene
			savedata.player_inventory = Utils.get_player_inventory()
			savedata.player_direction = player.facing_direction
			savedata.player_position = player.position
			Utils.save_game(savedata)
		"Exit":
			menu.visible = false
			current_screen = CURRENTSCREEN.NOTHING
			player.can_act = true
