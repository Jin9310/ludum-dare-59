extends Area2D

@onready var the_game = get_node("/root/TheGame")
@onready var signal_lost: Area2D = $"."
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var item_score: int = 10
var mult: int = 1


func _on_body_entered(body: Node2D) -> void:
	var rand = randi_range(0,3)
	GameManager.get_score(item_score, mult)
	audio_stream_player.play()
	the_game.hide_or_display(rand)
	change_position()

func change_position():
	#320 x 180
	var randx = randi_range(100,220)
	var randy = randi_range(50, 130)
	
	signal_lost.position = Vector2(randx, randy)


func _on_timer_timeout() -> void:
	if GameManager.game_started:
		change_position()
