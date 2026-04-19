#class_name Player
extends CharacterBody2D

# -- Tuning --
const GRAVITY = 450.0
const MOVE_SPEED = 100.0
const JUMP_FORCE = 200.0
const DOUBLE_JUMP_FORCE = 150.0
const DASH_SPEED = 250.0
const DASH_DURATION = 0.18
const DASH_COOLDOWN = 0.6
const WALL_BOUNCE = 0.5

const YOUR_SPAWN_X = 160
const YOUR_SPAWN_Y = 90

# -- Unlockables --
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
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var jump_sfx: AudioStreamPlayer = $jump
@onready var dash_sfx: AudioStreamPlayer = $dash

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
		_update_animation()
		return

	# -- Gravity --
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0.0
		has_double_jumped = false

	# -- Horizontal movement --
	var dir = Input.get_axis("left", "right")
	if dir != 0.0:
		if GameManager.game_started:
			velocity.x = dir * MOVE_SPEED
			last_direction = dir
	else:
		velocity.x = move_toward(velocity.x, 0.0, MOVE_SPEED * 6.0 * delta)

	# -- Flip sprite --
	sprite_2d.flip_h = last_direction < 0.0

	if GameManager.game_started:
		_handle_input(delta)

	move_and_slide()
	_update_animation()

func _handle_input(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump_sfx.play()
		if is_on_floor():
			_jump(JUMP_FORCE)
		elif can_double_jump and not has_double_jumped:
			_jump(DOUBLE_JUMP_FORCE)
			has_double_jumped = true

	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	if Input.is_action_just_pressed("dash") and can_dash:
		dash_sfx.play()
		if dash_cooldown_timer <= 0.0:
			_dash()

func _jump(force: float) -> void:
	velocity.y = -force

func _dash() -> void:
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_cooldown_timer = DASH_COOLDOWN
	dash_direction = last_direction

# -- Single place that decides what animation plays --
func _update_animation() -> void:
	var next: String

	if is_dashing:
		next = "dash"
		pass
	elif not is_on_floor():
		if velocity.y < 0.0:
			next = "jump"
		else:
			next = "fall"
	elif abs(velocity.x) > 5.0:
		next = "run"
	else:
		next = "idle"

	# Only call play() if the animation actually needs to change
	# avoids restarting the same animation every frame
	if anim.current_animation != next:
		anim.play(next)

func reset():
	velocity = Vector2.ZERO
	has_double_jumped = false
	is_dashing = false
	dash_timer = 0.0
	dash_cooldown_timer = 0.0
	position = Vector2(YOUR_SPAWN_X, YOUR_SPAWN_Y)
