extends Node

var player_inventory: PlayerInventory
var player_direction: Vector2
var player_position: Vector2
var loaded: bool = false

func _ready() -> void:
	start()
	
func start() -> void:
	# Practice Loading
	var savedata = get_save()
	if savedata:
		loaded = true
	#player_inventory = PlayerInventory.new()

func get_player_inventory() -> PlayerInventory:
	return player_inventory
	
func set_player_inventory(updated_inv: PlayerInventory) -> void:
	player_inventory = updated_inv

func save_game(savedata: SaveData) -> void:
	SaveGame.save(savedata)
	
func get_save() -> SaveData:
	return SaveGame.load_save()
	

func get_scene_manager() -> Object:
	return get_node("/root/SceneManager")
	
func get_player() -> Object:
	var scene = get_scene_manager()
	return scene.get_node("CurrentScene").get_children().back().find_children("Player").back()
