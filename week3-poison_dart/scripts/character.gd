extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var PassiveControll = get_tree().get_root().get_node("Node2D/Character/CharacterPasif")
var jumpBoostStat
const SPEED = 150.0
const JUMP_VELOCITY = -200.0
const JUMP_BOOST_VELOCITY = -600.0

func _process(delta):
	jumpBoostStat = PassiveControll.get_node("JumpProg").value / PassiveControll.get_node("JumpProg").max_value

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("Attack!")
			# kirim arah slash sesuai dengan arah hadap karakter
			$AttackArea.update_direction(anim.scale.x < 0)
			# trigger slash
			$AttackArea.start_slash()


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("jump_boost") and is_on_floor():
		if(jumpBoostStat == 1.0):
			velocity.y = JUMP_BOOST_VELOCITY
			PassiveControll.reset(PassiveControll.get_node("JumpProg"))
		
	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		anim.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
