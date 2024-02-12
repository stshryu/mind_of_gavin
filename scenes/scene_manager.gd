extends Node2D

var next_scene: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScreenTransition/ColorRect.visible = false
	pass # Replace with function body.

func transition_to_scene(new_scene: String):
	next_scene = new_scene
	$ScreenTransition/ColorRect.visible = true
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	
func finish_fading() -> void:
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(next_scene).instantiate())
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
