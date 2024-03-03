extends Node

var save_data: SaveData
var player_inventory: PlayerInventory
var player_direction: Vector2
var player_position: Vector2

func _ready() -> void:
	start()
	
func start() -> void:
	player_inventory = PlayerInventory.new()

func get_player_inventory() -> PlayerInventory:
	return player_inventory
	
func set_player_inventory(updated_inv: PlayerInventory) -> void:
	player_inventory = updated_inv

func save_game() -> void:
	SaveGame.save(save_data)
	
func _save_game_state() -> void:
	save_data.player_inventory = player_inventory
	save_data.player_direction = player_direction
	save_data.player_position = player_position
	
func get_scene_manager() -> Object:
	return get_node("/root/SceneManager")
	
func get_player() -> Object:
	var scene = get_scene_manager()
	return scene.get_node("CurrentScene").get_children().back().find_children("Player").back()
