extends Node

var player_inventory: PlayerInventory

func _ready() -> void:
	start()
	
func start() -> void:
	# logic to read/write save file should go here eventually
	player_inventory = PlayerInventory.new()

func get_player_inventory() -> PlayerInventory:
	return player_inventory
	
func set_player_inventory(updated_inv: PlayerInventory) -> void:
	player_inventory = updated_inv

func get_scene_manager() -> Object:
	return get_node("/root/SceneManager")
	
func get_player() -> Object:
	var scene = get_scene_manager()
	return scene.get_node("CurrentScene").get_children().back().find_children("Player").back()
