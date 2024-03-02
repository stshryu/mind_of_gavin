extends Node2D

var file_path = "user://save/"
var file_name = "SaveData.tres"

func _ready() -> void:
	_prepare_directory(file_path)
	
func _prepare_directory(path: String) -> void:
	DirAccess.make_dir_absolute(path)

func save(data: SaveData) -> void:
	ResourceSaver.save(data, file_path + file_name)
	
func load_save() -> SaveData:
	var save_data = ResourceLoader.load(file_path + file_name)
	return save_data.duplicate(true) if save_data else SaveData.new()
