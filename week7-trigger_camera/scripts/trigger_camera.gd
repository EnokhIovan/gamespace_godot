extends Area2D

## Di Inspector, atur nilai zoom_in dan zoom_out sesuai kebutuhan.

@export var zoom_in: float = 0.5
@export var zoom_out: float = 1.0
@export var zoom_speed: float = 2.0

var camera: Camera2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		camera = body.get_node_or_null("Camera2D")
		if camera:
			_tween_zoom(zoom_in)

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		if camera:
			_tween_zoom(zoom_out)

func _tween_zoom(target_zoom: float):
	var tween = create_tween()
	tween.tween_property(
		camera,
		"zoom",
		Vector2(target_zoom, target_zoom),
		1.0 / zoom_speed
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
