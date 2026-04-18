class_name Player
extends CharacterBody2D

# -- Tuning --
const GRAVITY = 400.0
const MOVE_SPEED = 30.0
const JUMP_FORCE = 50.0
const DOUBLE_JUMP_FORCE = 60.0
const DASH_SPEED = 60.0
const DASH_DURATION = 0.18
const DASH_COOLDOWN = 0.6
const WALL_BOUNCE = 0.5

# -- Unlockables (on by default, lock by setting false later) --
var can_double_jump: bool = true
var can_dash: bool = true

# -- State --
var has_double_jumped: bool = false
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: float = 1.0
var last_direction: float = 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# -- Dash takes full control while active --
	if is_dashing:
		dash_timer -= delta
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0.0
		if dash_timer <= 0.0:
			is_dashing = false
		move_and_slide()
		return

	# -- Gravity --
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0
		has_double_jumped = false

	# -- Horizontal movement --
	var dir = Input.get_axis("ui_left", "ui_right")
	if dir != 0.0:
		velocity.x = dir * MOVE_SPEED
		last_direction = dir
	else:
		velocity.x = move_toward(velocity.x, 0.0, MOVE_SPEED * 6.0 * delta)

	# -- Flip sprite --
	sprite_2d.flip_h = last_direction < 0.0

	_handle_input(delta)
	move_and_slide()
	_handle_wall_bounce()

func _handle_input(delta: float) -> void:
	# -- Jump --
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			_jump(JUMP_FORCE)
		elif can_double_jump and not has_double_jumped:
			_jump(DOUBLE_JUMP_FORCE)
			has_double_jumped = true

	# -- Dash --
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	if Input.is_action_just_pressed("ui_select") and can_dash:
		if dash_cooldown_timer <= 0.0:
			_dash()

func _jump(force: float) -> void:
	velocity.y = -force

func _dash() -> void:
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_cooldown_timer = DASH_COOLDOWN
	dash_direction = last_direction

func _handle_wall_bounce() -> void:
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider().is_in_group("wall"):
			velocity.x = -velocity.x * WALL_BOUNCE
