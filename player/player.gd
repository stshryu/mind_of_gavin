extends CharacterBody2D

@export var walk_speed: float = 4.0
@export var jump_speed: float = 8.0 

const TILE_SIZE: int = 16
const dust_effect = preload("res://scenes/landing_dust_effect.tscn")

@onready var small_shadow = $SmallShadow
@onready var large_shadow = $LargeShadow
@onready var anim_tree = $anim_tree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var ray = $RayCast2D

enum PlayerState { IDLE, TURNING, MOVING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN
# Allows us instant directional changes while moving while keeping turn functionality while standing still.
var prev_player_state = PlayerState.IDLE 

var init_pos: Vector2 = Vector2.ZERO
var input_dir: Vector2 = Vector2.ZERO
var is_moving: bool = false
var is_jumping: bool = false
var percent_moved: float = 0.0
# Each key is added to a stack and removed as keys are depressed (for emulating GBA movements) 
var direction_keys: Array = [] 

func player_input() -> void:
	if len(direction_keys) == 0 or direction_keys.back() == null:
		input_dir = Vector2.ZERO
		prev_player_state = PlayerState.IDLE
	else:
		var key: String = direction_keys.back()
		if Input.is_action_pressed(key):
			input_dir = Vector2.ZERO
			if key == "ui_right":
				input_dir.x = 1
			elif key == "ui_left":
				input_dir.x = -1
			elif key == "ui_down":
				input_dir.y = 1
			elif key == "ui_up":
				input_dir.y = -1
			else:
				input_dir = Vector2.ZERO
	
	if input_dir != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_dir)
		anim_tree.set("parameters/Walk/blend_position", input_dir)
		anim_tree.set("parameters/Turn/blend_position", input_dir)

		if need_to_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			prev_player_state = PlayerState.MOVING
			init_pos = position
			is_moving = true
	else:
		anim_state.travel("Idle")

func need_to_turn() -> bool:
	if prev_player_state == PlayerState.MOVING:
		return false
	
	var new_facing_dir
	if input_dir.x < 0:
		new_facing_dir = FacingDirection.LEFT
	elif input_dir.x > 0:
		new_facing_dir = FacingDirection.RIGHT
	elif input_dir.y < 0:
		new_facing_dir = FacingDirection.UP
	elif input_dir.y > 0:
		new_facing_dir = FacingDirection.DOWN

	if facing_direction != new_facing_dir:
		facing_direction = new_facing_dir
		return true

	facing_direction = new_facing_dir
	return false

func finished_turning() -> void:
	player_state = PlayerState.IDLE

func jump(delta: float) -> void:
	percent_moved += jump_speed * delta

	if percent_moved >= 1.99:
		small_shadow.visible = false
		large_shadow.visible = false
		var landing_dust_effect = dust_effect.instantiate()
		landing_dust_effect.position = position
		get_tree().current_scene.add_child(landing_dust_effect)
		
		position = init_pos + (TILE_SIZE * input_dir) * 2
		percent_moved = 0.0
		is_jumping = false
		input_dir = Vector2.ZERO
	else:
		small_shadow.visible = true if percent_moved <= 1.0 else false
		large_shadow.visible = true if percent_moved > 1.0 else false
		position = init_pos + (TILE_SIZE * input_dir * percent_moved)
	
func move(delta: float) -> void:
	var next_step = input_dir * TILE_SIZE / 2
	ray.target_position = next_step
	ray.force_raycast_update()

	if !ray.is_colliding():
		percent_moved += walk_speed * delta
		if percent_moved >= 0.99:
			position = init_pos + (TILE_SIZE * input_dir)
			percent_moved = 0.0
			is_moving = false
		else:
			position = init_pos + (TILE_SIZE * input_dir * percent_moved)
	else:
		var target = ray.get_collider()
		if target.name.contains("Ledge"):
			if is_jumpable(target, input_dir):
				is_jumping = true
		is_moving = false

func _ready() -> void:
	anim_tree.active = true
	init_pos = position
	
	small_shadow.visible = false
	large_shadow.visible = false

func is_jumpable(target: Object, movement: Vector2) -> bool:
	if target.direction == movement:
		return true
	return false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		direction_keys.push_back("ui_right")
	elif Input.is_action_just_released("ui_right"):
		direction_keys.erase("ui_right")
	if Input.is_action_just_pressed("ui_left"):
		direction_keys.push_back("ui_left")
	elif Input.is_action_just_released("ui_left"):
		direction_keys.erase("ui_left")
	if Input.is_action_just_pressed("ui_down"):
		direction_keys.push_back("ui_down")
	elif Input.is_action_just_released("ui_down"):
		direction_keys.erase("ui_down")
	if Input.is_action_just_pressed("ui_up"):
		direction_keys.push_back("ui_up")
	elif Input.is_action_just_released("ui_up"):
		direction_keys.erase("ui_up")
	if !Input.is_action_pressed("ui_right") and \
		!Input.is_action_pressed("ui_left") and \
		!Input.is_action_pressed("ui_down") and \
		!Input.is_action_pressed("ui_up"):
			direction_keys.clear()

func _physics_process(delta: float) -> void:
	if player_state == PlayerState.TURNING:
		return
	elif not is_moving and not is_jumping:
		player_input()
	elif not is_moving and is_jumping:
		jump(delta)
	elif input_dir != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false
