extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("kill player")
		GameManager.game_over = true
		body.queue_free()
	
	if body.is_in_group("platform"):
		print("kill platform")
		body.queue_free()
