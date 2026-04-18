extends Area2D

@onready var the_game = get_node("/root/TheGame")
@onready var signal_lost: Area2D = $"."


func _on_body_entered(body: Node2D) -> void:
	var rand = randi_range(0,3)
	the_game.hide_or_display(rand)
	change_position()

func change_position():
	#320 x 180
	var randx = randi_range(100,220)
	var randy = randi_range(50, 130)
	
	signal_lost.position = Vector2(randx, randy)


func _on_timer_timeout() -> void:
	change_position()
