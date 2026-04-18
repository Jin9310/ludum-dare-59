class_name the_game
extends Node2D

# mame
# spawn a pohyb platform
# zakladni moveset - muzem zamknout double jump a dash
# 
# chybi
# UI
# collectibles - vypnout monitor/zapnout monitor
# vypinani/zapinani obrazovek - tusime jak
# shader na CRT efekty
# chybi dostavat body!



@onready var viewport := $GameViewport
@onready var monitors: Array = [$A/MonitorA, $B/MonitorB, $C/MonitorC, $D/MonitorD]

func _ready() -> void:
	# na random vypnout 2 obrazovky hned na zacatku
	
	viewport.size = Vector2i(320, 180)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var tex = viewport.get_texture()
	for m in monitors:
		m.texture = tex
		m.stretch_mode = TextureRect.STRETCH_SCALE

func _process(delta: float) -> void:
	if GameManager.game_over:
		if Input.is_action_just_pressed("reset"):
			get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"):
		hide_or_display(0)

func hide_or_display(monitor_number: int):
	if monitors[monitor_number].visible == true:
		monitors[monitor_number].visible = false
	else:
		monitors[monitor_number].visible = true
