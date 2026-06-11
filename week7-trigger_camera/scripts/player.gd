extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D
@onready var tilemap: TileMapLayer = get_parent().get_node("TileMapLayer")

@export var zoom_speed: float = 2.0
@export var default_zoom: float = 4.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var current_zoom: float = 4.0
var speed_multiplier: float = 1.0  # 1.0 = normal, 0.5 = setengah kecepatan

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	_check_camera_zone()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED * speed_multiplier  # ← kena multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _check_camera_zone():
	var tile_pos = tilemap.local_to_map(tilemap.to_local(global_position))
	var tile_data = tilemap.get_cell_tile_data(tile_pos)

	if tile_data:
		var zoom_val = tile_data.get_custom_data("zoom_level")
		var slow_val = tile_data.get_custom_data("speed_multiplier")

		# Zoom
		if zoom_val and zoom_val > 0.0:
			_tween_zoom(zoom_val)
		else:
			_tween_zoom(default_zoom)

		# Slow
		if slow_val and slow_val > 0.0:
			speed_multiplier = slow_val
		else:
			speed_multiplier = 1.0

		return

	_tween_zoom(default_zoom)
	speed_multiplier = 1.0

func _tween_zoom(target: float):
	if abs(current_zoom - target) < 0.01:
		return
	current_zoom = target
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(target, target), 1.0 / zoom_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
