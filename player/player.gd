extends CharacterBody2D

@onready var ray_cast: RayCast2D = $CollisionRaycast
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_tree_properties = $AnimationTree.get("parameters/playback")

const TILE_SIZE: int = 16
@export var walk_speed: int = 6

var init_pos: Vector2 = Vector2.ZERO
var input_dir: Vector2 = Vector2.ZERO

var is_moving: bool = false
var is_running: bool = false
var percent_moved: float = 0.0 # Amount moved to next tile

var next_step: Vector2

func _ready() -> void:
	anim_tree.active = true
	anim_tree_properties.travel("Idle")

func player_input() -> void:
	if input_dir.y == 0:
		input_dir.x = Input.get_axis("ui_left", "ui_right")
	if input_dir.x == 0:
		input_dir.y = Input.get_axis("ui_up", "ui_down")

	next_step = input_dir * TILE_SIZE

	ray_cast.target_position = next_step
	ray_cast.force_raycast_update()

	if Input.is_action_pressed("ui_select"):
		is_running = true
		walk_speed = 12

	if not ray_cast.is_colliding():
		if input_dir != Vector2.ZERO:
			init_pos = position
			is_moving = true

func move(delta: float) -> void:
	percent_moved += walk_speed * delta

	if percent_moved >= 1.0:
		position = init_pos + next_step
		percent_moved = 0.0
		is_moving = false
	else:
		position = init_pos + (next_step * percent_moved)

func animation() -> void:
	if input_dir != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_dir)
		anim_tree.set("paremeters/Walk/blend_position", input_dir)

		if is_running:
			anim_tree_properties.travel("Walk")
		else:
			anim_tree_properties.travel("Walk")
	else:
		anim_tree_properties.travel("Idle")

func _physics_process(delta: float) -> void:
	if not is_moving:
		anim_tree_properties.travel("Idle")
		player_input()
	elif is_moving:
		move(delta)
		animation()
