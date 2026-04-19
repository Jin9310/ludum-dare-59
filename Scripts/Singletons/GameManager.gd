extends Node

signal score_changed(new_score)

# 50 max?
# 25 starting speed
var base_platform_speed: float = 25.0
var current_platform_speed: float
var speed_incremet: float = 5.0

var game_over: bool = false
var game_started: bool = false

var score: int = 0

func reset_stats():
	game_over = false
	score = 0
	current_platform_speed = base_platform_speed

func get_score(points: int, multiplier: int):
	score += points * multiplier
	score_changed.emit(score)
