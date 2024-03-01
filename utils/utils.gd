extends Node

var player_inventory: PlayerInventory

func _ready() -> void:
	start()
	
func start() -> void:
	# logic to read/write save file should go here eventually
	player_inventory = PlayerInventory.new()
	var small_health_potion = load("res://models/items/potions/small_health_potion.tres")
	var small_mana_potion = load("res://models/items/potions/small_mana_potion.tres")
	player_inventory.inventory["KeyItems"] = [small_health_potion, small_mana_potion]

func get_player_inventory() -> PlayerInventory:
	return player_inventory

func get_scene_manager() -> Object:
	return get_node("/root/SceneManager")
	
func get_player() -> Object:
	var scene = get_scene_manager()
	return scene.get_node("CurrentScene").get_children().back().find_children("Player").back()
