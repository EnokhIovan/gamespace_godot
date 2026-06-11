extends ColorRect

## HeartbeatEffect.gd
## Attach ke node ColorRect yang ada di dalam CanvasLayer

@export var low_hp_threshold: float = 0.3  # efek mulai di bawah 30% HP
@export var pulse_speed: float = 2.0

var is_pulsing: bool = false
var tween: Tween

func _ready():
	# Pastikan tidak menghalangi input
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Mulai transparan
	color = Color(1, 0, 0, 0)

	# Shader vignette merah di pinggir layar
	var shader_code = """
shader_type canvas_item;
uniform float alpha = 0.0;
void fragment() {
	vec2 uv = UV;
	float dist = distance(uv, vec2(0.5, 0.5));
	float vignette = smoothstep(0.3, 0.75, dist);
	COLOR = vec4(1.0, 0.0, 0.0, vignette * alpha);
}
"""
	var shader = Shader.new()
	shader.code = shader_code
	var mat = ShaderMaterial.new()
	mat.shader = shader
	material = mat

func update_hp(current_hp: float, max_hp: float):
	print("update_hp called: ", current_hp, "/", max_hp)
	var ratio = current_hp / max_hp
	if ratio <= low_hp_threshold:
		if not is_pulsing:
			_start_pulse(ratio)
	else:
		_stop_pulse()

func _start_pulse(hp_ratio: float):
	is_pulsing = true
	# Makin rendah HP, makin cepat denyutnya
	var speed = pulse_speed + (1.0 - hp_ratio / low_hp_threshold) * 3.0
	_do_pulse(speed)

func _do_pulse(speed: float):
	if not is_pulsing:
		return
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(_set_alpha, 0.0, 0.85, 0.5 / speed)
	tween.tween_method(_set_alpha, 0.85, 0.0, 0.5 / speed)
	tween.tween_callback(_do_pulse.bind(speed))

func _stop_pulse():
	is_pulsing = false
	if tween:
		tween.kill()
	_set_alpha(0.0)

func _set_alpha(value: float):
	if material:
		material.set_shader_parameter("alpha", value)
