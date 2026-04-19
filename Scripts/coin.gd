extends Area2D

@onready var coin: Area2D = $"."

var item_score: int = 1
var mult: int = 1
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer




func _on_body_entered(body: Node2D) -> void:
	GameManager.get_score(item_score, mult)
	audio_stream_player.play()
	change_position()


func change_position():
	#320 x 180
	var randx = randi_range(100,220)
	var randy = randi_range(50, 130)
	
	coin.position = Vector2(randx, randy)


func _on_timer_timeout() -> void:
	change_position()
