extends Area2D

@export_file var next_scene_path = ""
@export var door_is_visible = true
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

@export var spawn_location: Vector2 = Vector2.ZERO
@export var spawn_direction: Vector2 = Vector2.ZERO

var player_entered: bool = false

func _ready():
	if not door_is_visible:
		$Sprite2D.texture = null
	sprite.visible = false
	var player = find_parent("CurrentScene").get_children().back().find_child("Player")
	player.player_entering_door.connect(enter_door)
	player.player_entered_door.connect(close_door)
	
func enter_door():
	if player_entered: anim_player.play("OpenDoor")
	
func close_door():
	if player_entered: anim_player.play("CloseDoor")
	
func transition_scene():
	if player_entered: get_node(NodePath("/root/SceneManager")) \
		.transition_to_scene(next_scene_path, spawn_location, spawn_direction)

func _on_body_entered(body):
	player_entered = true

func _on_body_exited(body):
	player_entered = false
