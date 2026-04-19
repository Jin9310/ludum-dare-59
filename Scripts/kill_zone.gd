extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("kill player")
		audio_stream_player.play()
		GameManager.game_over = true
		GameManager.game_started = false
		body.queue_free()
	
	if body.is_in_group("platform"):
		print("kill platform")
		body.queue_free()
