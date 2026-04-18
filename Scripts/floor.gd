extends StaticBody2D

var width: float
@onready var floor = $"."

func _ready():
	var rand = randi_range(1,3)
	floor.scale.x = rand
	

func _physics_process(delta):
	position.y += GameManager.platform_speed * delta
