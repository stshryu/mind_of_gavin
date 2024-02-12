extends Area2D

@export_file var next_scene_path = ""
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

func _ready():
	sprite.visible = false
	var player = find_parent("CurrentScene").get_children().back().find_child("Player")
	player.player_entering_door.connect(enter_door)
	player.player_entered_door.connect(close_door)
	
func enter_door():
	anim_player.play("OpenDoor")
	
func close_door():
	anim_player.play("CloseDoor")
	
func transition_scene():
	get_node(NodePath("/root/SceneManager")).transition_to_scene(next_scene_path)
