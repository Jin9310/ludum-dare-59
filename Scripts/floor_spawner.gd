extends Node2D

var platform = preload("res://Scenes/floor.tscn")


func _on_timer_timeout():
	spawn_platform()

func spawn_platform():
	var plat = platform.instantiate()
	var rand_pos = randi_range(50, 250)
	plat.position.x = rand_pos
	add_child(plat)
