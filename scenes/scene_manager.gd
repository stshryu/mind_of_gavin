extends Node2D

var next_scene # can either be a PackedScene or string
var player_location: Vector2 = Vector2.ZERO
var player_direction: Vector2 = Vector2.ZERO

func _ready():
	$ScreenTransition/ColorRect.visible = false
	if Utils.loaded:
		var savedata = Utils.get_save()
		var scene_path = SaveGame.scene_path
		transition_to_scene(scene_path, savedata.player_position, savedata.player_direction)
		
func transition_to_scene(new_scene, spawn_location: Vector2, spawn_direction: Vector2) -> void:
	next_scene = new_scene
	player_location = spawn_location
	player_direction = spawn_direction
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	
func finish_fading() -> void:
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(next_scene).instantiate())
	var player = Utils.get_player()
	player.set_spawn(player_location, player_direction)
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")
