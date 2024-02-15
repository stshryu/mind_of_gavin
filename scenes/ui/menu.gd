extends CanvasLayer

@onready var select_arrow = $Control/NinePatchRect/SelectArrow
@onready var menu = $Control
@onready var vboxcontainer = $Control/NinePatchRect/VBoxContainer
@onready var partyscreen = $PartyScreen

@export var init_y: int = 7
@export var offset_y: int = 16

enum CURRENTSCREEN { NOTHING, MENU, PARTYSCREEN }
var current_screen = CURRENTSCREEN.NOTHING
var selected_option: int = 0
var menu_options: Array
var menu_opt_length: int 
var player: Object

func _ready():
	menu_options = vboxcontainer.get_children()
	menu_opt_length = menu_options.size()
	menu.visible = false
	partyscreen.visible = false
	select_arrow.position.y = init_y + (selected_option % menu_opt_length) * offset_y

func _get_player_instance() -> void:
	var current_scene = get_parent().get_node("CurrentScene").get_children().back()
	player = current_scene.find_children("Player").back()
	
func _unhandled_input(event):
	_get_player_instance()
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
				#get_parent().transition_to_party_screen()
			elif event.is_action_pressed("ui_down"):
				selected_option += 1
				select_arrow.position.y = init_y + (selected_option % menu_opt_length) * offset_y
			elif event.is_action_pressed("ui_up"):
				selected_option = menu_opt_length - 1 if selected_option == 0 else selected_option - 1
				select_arrow.position.y = init_y + (selected_option % menu_opt_length) * offset_y
		CURRENTSCREEN.PARTYSCREEN:
			if event.is_action_pressed("back"):
				menu.visible = true
				partyscreen.visible = false
				current_screen = CURRENTSCREEN.MENU

func _menu_options() -> void:
	var current_selection = menu_options[selected_option % menu_opt_length]
	match current_selection.name:
		"Pokemon":
			menu.visible = false
			partyscreen.visible = true
			current_screen = CURRENTSCREEN.PARTYSCREEN
		"Bag":
			print_debug("bag")
		"Player":
			print_debug("player")
		"Options":
			print_debug("options")
		"Save":
			print_debug("save")
		"Exit":
			menu.visible = false
			current_screen = CURRENTSCREEN.NOTHING
			player.can_act = true
