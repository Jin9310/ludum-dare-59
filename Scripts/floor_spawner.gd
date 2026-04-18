extends Node2D

var platform = preload("res://Scenes/floor.tscn")
var counter: int = 0
var speed_up: int = 10

@onready var timer: Timer = $Timer

func _ready() -> void:
	GameManager.current_platform_speed = GameManager.base_platform_speed
	timer.wait_time = 1.5

func _on_timer_timeout():
	counter += 1
	spawn_platform()
	if counter >= speed_up:
		if GameManager.current_platform_speed <= 60:
			GameManager.current_platform_speed += GameManager.speed_incremet
			counter = 0 

func spawn_platform():
	var plat = platform.instantiate()
	var rand_pos = randi_range(50, 250)
	plat.position.x = rand_pos
	add_child(plat)
