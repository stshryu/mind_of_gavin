extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var GRASS_OVERLAY_TEXTURE = preload("res://art/grass/stepped_tall_grass.png")
@onready var GRASS_STEP_EFFECT = preload("res://scenes/terrain/grass_step_effect.tscn")

var grass_overlay: TextureRect = null

func _ready():
	pass
	
func body_entering_grass() -> void:
	_play_grass_step_effect()
	_create_tall_grass()

func body_exiting_grass() -> void:
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()

func _play_grass_step_effect() -> void:
	var grass_step_effect = GRASS_STEP_EFFECT.instantiate()
	grass_step_effect.position = position
	get_tree().current_scene.add_child(grass_step_effect)
	
func _create_tall_grass() -> void:
	grass_overlay = TextureRect.new()
	grass_overlay.texture = GRASS_OVERLAY_TEXTURE
	grass_overlay.position = position
	grass_overlay.z_index = 1
	get_tree().current_scene.add_child(grass_overlay)

func _on_area_2d_body_entered(_body):
	body_entering_grass()
	anim_player.play("Stepped")

func _on_area_2d_body_exited(_body):
	body_exiting_grass()
