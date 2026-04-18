extends Node2D

@onready var viewport := $GameViewport
@onready var monitors := [$A/MonitorA, $B/MonitorB, $C/MonitorC, $D/MonitorD]

func _ready() -> void:
	viewport.size = Vector2i(320, 180)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var tex = viewport.get_texture()
	for m in monitors:
		m.texture = tex
		m.stretch_mode = TextureRect.STRETCH_SCALE
