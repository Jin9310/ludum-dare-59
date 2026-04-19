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

@onready var play_btn: Button = $UI/Control/CenterContainer/VBoxContainer/play_btn
@onready var control: Control = $UI/Control


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

func _on_monitors_changed(count: int) -> void:
	for i in monitors.size():
		var mat = monitors[i].material as ShaderMaterial
		if i >= count:
			# Animate shutoff_progress from 0 to 1 over 1 second
			var tween = create_tween()
			tween.tween_method(
				func(v): mat.set_shader_parameter("shutoff_progress", v),
				0.0, 1.0, 1.0
			)
		else:
			mat.set_shader_parameter("shutoff_progress", 0.0)


func _on_button_pressed() -> void:
	control.visible = false
	GameManager.game_started = true
	GameManager.game_over = false
