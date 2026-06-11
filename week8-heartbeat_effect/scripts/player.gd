extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D
@onready var tilemap: TileMapLayer = get_parent().get_node("TileMapLayer")
@onready var heartbeat: ColorRect = $Heartbeat/ColorRect
@onready var healthBar: ProgressBar = $HP/ProgressBar

@export var zoom_speed: float = 2.0
@export var default_zoom: float = 4.0
@export var damage_interval: float = 0.5
@export var max_hp: float = 100.0
@export var feet_offset: float = 16.0

var hp: float = 100.0
var current_zoom: float = 4.0
var speed_multiplier: float = 1.0
var damage_timer: float = 0.0

const SPEED = 200.0
const JUMP_VELOCITY = -200.0

func _ready() -> void:
	healthBar.max_value = max_hp
	healthBar.value = hp

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	_check_camera_zone(delta)
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func take_damage(amount: float) -> void:
	hp = clamp(hp - amount, 0, max_hp)
	_update_ui()

func heal(amount: float) -> void:
	hp = clamp(hp + amount, 0, max_hp)
	_update_ui()

func _update_ui() -> void:
	healthBar.value = hp
	heartbeat.update_hp(hp, max_hp)

func _check_camera_zone(delta: float) -> void:
	var feet_pos = global_position + Vector2(0, feet_offset)
	var tile_pos = tilemap.local_to_map(tilemap.to_local(feet_pos))
	var tile_data = tilemap.get_cell_tile_data(tile_pos)

	if tile_data:
		var zoom_val = tile_data.get_custom_data("zoom_level")
		var slow_val = tile_data.get_custom_data("speed_multiplier")
		var dmg_val  = tile_data.get_custom_data("damage")
		var heal_val = tile_data.get_custom_data("heal")

		_tween_zoom(zoom_val if (zoom_val and zoom_val > 0.0) else default_zoom)
		speed_multiplier = slow_val if (slow_val and slow_val > 0.0) else 1.0

		if dmg_val and dmg_val > 0.0:
			damage_timer += delta
			if damage_timer >= damage_interval:
				damage_timer = 0.0
				take_damage(dmg_val)
		elif heal_val and heal_val > 0.0:  # ← tambah ini
			damage_timer += delta
			if damage_timer >= damage_interval:
				damage_timer = 0.0
				heal(heal_val)
		else:
			damage_timer = 0.0
		return

	_tween_zoom(default_zoom)
	speed_multiplier = 1.0
	damage_timer = 0.0

func _tween_zoom(target: float) -> void:
	if abs(current_zoom - target) < 0.01:
		return
	current_zoom = target
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(target, target), 1.0 / zoom_speed) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
