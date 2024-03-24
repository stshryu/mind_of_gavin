extends Node2D

# The base macos dirpath is:
# ~/Library/Application Support/Godot/app_userdata/[mind_of_gavin]
# The base windows dirpath is:
# %APPDATA%\Godot\app_userdata\[mind_of_gavin]
var dir_path = "user://save/"
var file_name = "SaveData.tres"
var scene_name = "SaveDataScene.tscn"
var file_path = dir_path + file_name
var scene_path = dir_path + scene_name

func _ready() -> void:
	_prepare_directory(dir_path)
	
func _prepare_directory(path: String) -> void:
	DirAccess.make_dir_absolute(path)

func save(data: SaveData, scene: PackedScene) -> void:
	var data_status = ResourceSaver.save(data, file_path)
	var scene_status = ResourceSaver.save(scene, scene_path)
	
func load_save() -> SaveData:
	var save_exists := FileAccess.file_exists(file_path)
	return ResourceLoader.load(file_path).duplicate(true) if save_exists else null
	
