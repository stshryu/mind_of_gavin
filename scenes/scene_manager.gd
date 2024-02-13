extends Node2D

var next_scene: String = ""
var player_location: Vector2 = Vector2.ZERO
var player_direction: Vector2 = Vector2.ZERO

func _ready():
	$ScreenTransition/ColorRect.visible = false

func transition_to_scene(new_scene: String, spawn_location: Vector2, spawn_direction: Vector2) -> void:
	next_scene = new_scene
	player_location = spawn_location
	player_direction = spawn_direction
	$ScreenTransition/ColorRect.visible = true
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	
func finish_fading() -> void:
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(next_scene).instantiate())
	var player = $CurrentScene.get_children().back().find_child("Player")
	player.set_spawn(player_location, player_direction)
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")

func _process(delta):
	pass
