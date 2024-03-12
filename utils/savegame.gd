extends Node2D

var dir_path = "user://save/"
var file_name = "SaveData.tres"
var file_path = dir_path + file_name

func _ready() -> void:
	_prepare_directory(dir_path)
	
func _prepare_directory(path: String) -> void:
	DirAccess.make_dir_absolute(path)

func save(data: SaveData) -> void:
	var res = ResourceSaver.save(data, file_path)
	print(res)
	
func load_save() -> SaveData:
	var save_exists := FileAccess.file_exists(file_path)
	return ResourceLoader.load(file_path).duplicate(true) if save_exists else SaveData.new()
