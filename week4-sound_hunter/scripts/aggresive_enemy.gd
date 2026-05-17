extends CharacterBody2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var rayF: RayCast2D = $WallCheckFront
@onready var rayU: RayCast2D = $WallCheckUp
@onready var zone: Area2D = $Zone
@onready var attZone: Area2D = $AttackZone

var CharAttr = {
	"movement": {
		"speed": 60.0,
		"jump": -200.0,
	},
	"combat": {
		"hp": 100,
		"def": 0.15,
		"atk": 20,
		"crit": 0.05
	}
}

var dir_vector: Vector2
var dir_x: float = 1
var chase_delay = 0.5
var chase_timer = chase_delay
var isSleeping = true;
var isPlayerEnteredZone = false
var isEverTouchedPlayer = false

func _on_zone_body_entered(body):
	if body.name == "Player":
		isPlayerEnteredZone = true
		chase_timer = chase_delay

func _on_zone_body_exited(body):
	if body.name == "Player":
		isPlayerEnteredZone = false

func _on_attZone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !isEverTouchedPlayer:
		apply_attack(body)

func check_wake_condition():
	if !isSleeping:
		return

	if !isPlayerEnteredZone:
		return

	# Player lagi sneak → jangan bangun
	if Input.is_action_pressed("ui_sneak"):
		return

	# Player diem total → jangan bangun juga
	var input_x = Input.get_axis("ui_left", "ui_right")
	if input_x == 0:
		return

	# Oke, sekarang bangun
	animSprite.play("spawn")
	await animSprite.animation_finished
	animSprite.play("idle")
	isSleeping = false

func apply_attack(body):
	var atkObj = {
		"atk": CharAttr.combat.atk,
		"crit": CharAttr.combat.crit
	}

	body.take_damage(atkObj)
	isEverTouchedPlayer = true
	body.apply_knockback(global_position, 200)

func update_navigation(delta):
	if isPlayerEnteredZone:
		chase_timer -= delta
		nav_agent.target_position = player.global_position
	else:
		nav_agent.target_position = global_position

func update_direction():
	dir_vector = global_position.direction_to(nav_agent.get_next_path_position())
	dir_x = sign(dir_vector.x)

func update_ray():
	rayF.target_position = Vector2(20 * dir_x, 0)

func handle_jump():
	if rayF.is_colliding() and is_on_floor():
		var hit = rayF.get_collider()

		if hit and !hit.is_in_group("player"):
			velocity.y = CharAttr.movement.jump

func handle_movement():
	if abs(dir_vector.x) < 0.2:
		velocity.x = 0
		return

	if chase_timer > 0:
		velocity.x = 0
	else:
		velocity.x = dir_vector.x * CharAttr.movement.speed
	$AnimatedSprite2D.flip_h = velocity.x < 0

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

func _physics_process(delta: float) -> void:
	await check_wake_condition()
	
	if isEverTouchedPlayer:
		if chase_timer > 0:
			chase_timer -= delta
			print("Chase time: ", chase_timer)
		else:
			isEverTouchedPlayer = false
			chase_timer = chase_delay

	handle_gravity(delta)
	update_navigation(delta)
	update_direction()
	update_ray()

	if !isEverTouchedPlayer and !isSleeping:
		handle_jump()
		handle_movement()

	move_and_slide()
