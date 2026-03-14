extends Node2D

signal btn_pressed(color)
@export var color: String
var player_in_area = false  # flag buat ngecek player lagi di area

func _ready() -> void:
	pass

# deteksi player masuk area
func _on_area_2d_body_entered(body: Node2D) -> void:
	if (self.frame == 0 and body.name == "Player"):
		player_in_area = true
		#print("Player masuk area")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (self.frame == 0 and body.name == "Player"):
		player_in_area = false
		#print("Player keluar area")

func _process(delta: float) -> void:
	if (player_in_area == true):
		if(Input.is_action_just_pressed("ui_text_newline")):
			self.frame = 1
			print("Tombol ", self.animation ," ditekan")
			emit_signal("btn_pressed", color)
			player_in_area = false
