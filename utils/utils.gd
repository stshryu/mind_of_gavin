extends Node

var player_inventory: PlayerInventory
var player_direction: int
var player_position: Vector2

func _ready() -> void:
	start()
	
func start() -> void:
	player_inventory = PlayerInventory.new()

func get_player_inventory() -> PlayerInventory:
	return player_inventory
	
func set_player_inventory(updated_inv: PlayerInventory) -> void:
	player_inventory = updated_inv

func save_game(savedata: SaveData) -> void:
	SaveGame.save(savedata)

func get_scene_manager() -> Object:
	return get_node("/root/SceneManager")
	
func get_player() -> Object:
	var scene = get_scene_manager()
	return scene.get_node("CurrentScene").get_children().back().find_children("Player").back()
