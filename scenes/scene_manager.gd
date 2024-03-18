extends Node2D

var next_scene # can either be a PackedScene or string
var player_location: Vector2 = Vector2.ZERO
var player_direction: Vector2 = Vector2.ZERO
var is_loading: bool = false

func _ready():
	$ScreenTransition/ColorRect.visible = false
	if Utils.loaded:
		var savedata = Utils.get_save()
		is_loading = true
		transition_to_scene(savedata.current_scene, savedata.player_position, savedata.player_direction)
		
func transition_to_scene(new_scene, spawn_location: Vector2, spawn_direction: Vector2) -> void:
	next_scene = new_scene
	player_location = spawn_location
	player_direction = spawn_direction
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	
func finish_fading() -> void:
	$CurrentScene.get_child(0).queue_free()
	if is_loading:
		$CurrentScene.add_child(next_scene.instantiate())
		is_loading = false
	else:
		$CurrentScene.add_child(load(next_scene).instantiate())
	var player = Utils.get_player()
	player.set_spawn(player_location, player_direction)
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")
