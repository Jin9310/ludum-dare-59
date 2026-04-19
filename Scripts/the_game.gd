class_name the_game
extends Node2D

@onready var music_loop: AudioStreamPlayer2D = $Music_loop

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
@onready var main: Node2D = $GameViewport/Main

@onready var play_btn: Button = $UI/Control/play_btn
@onready var control: Control = $UI/Control

@onready var ingame_ui: Control = $UI/Ingame_ui
@onready var score_lbl: Label = $UI/Ingame_ui/score_lbl

@onready var gameover_ui: Control = $UI/gameover_ui
@onready var final_score_name: Label = $UI/gameover_ui/final_score_name
@onready var final_score_number: Label = $UI/gameover_ui/final_score_number

@onready var viewport := $GameViewport
@onready var monitors: Array = [$A/MonitorA, $B/MonitorB, $C/MonitorC, $D/MonitorD]

func _ready() -> void:
	music_loop.play()
	music_loop.finished.connect(_on_audio_finished)
	
	main.visible = false
	
	score_lbl.text = "score: " + "0"
	GameManager.score_changed.connect(_on_score_changed)
	
	viewport.size = Vector2i(320, 180)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var tex = viewport.get_texture()
	for m in monitors:
		m.texture = tex
		m.stretch_mode = TextureRect.STRETCH_SCALE

func _on_audio_finished():
	music_loop.play()

func _process(delta: float) -> void:
	if GameManager.game_over:
		ingame_ui.visible = false
		gameover_ui.visible = true
		final_score_number.text = str(GameManager.score)
	
		if Input.is_action_just_pressed("reset"):
			GameManager.reset_stats()
			gameover_ui.visible = false
			get_tree().reload_current_scene()

func hide_or_display(monitor_number: int):
	if monitors[monitor_number].visible == true:
		monitors[monitor_number].visible = false
	else:
		monitors[monitor_number].visible = true
	_check_all_monitors_hidden()

func _check_all_monitors_hidden():
	var all_hidden = monitors.all(func(m): return not m.visible)
	if all_hidden:
		monitors[3].visible = true

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
	#GameManager.reset_stats()
	game_start_now()

func _on_score_changed(new_score: int):
	score_lbl.text = "score: " + str(new_score)

func _on_play_again_pressed() -> void:
	GameManager.reset_stats()
	gameover_ui.visible = false
	ingame_ui.visible = true
	_on_button_pressed()

func game_start_now():
	main.visible = true
	gameover_ui.visible = false
	control.visible = false
	ingame_ui.visible = true
	GameManager.game_started = true
	GameManager.game_over = false
