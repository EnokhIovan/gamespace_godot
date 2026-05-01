extends CharacterBody2D

var PlayerAttr = {
	"movement": {
		"speed": 150.0,
		"jump": -250.0,
	},
	"combat": {
		"hp": 100,
		"def": 0.20,
		"atk": 20,
		"crit": 0.05
	},
	"effects": {
		"slowness": 0.0
	}
}

var is_knockback = false
var knockback_time = 0.15
var knockback_timer = 0.0
var knockback_velocity = Vector2.ZERO

func take_damage(obj):
	PlayerAttr.combat.hp -= obj.atk
	print("Sisa HP: ", PlayerAttr.combat.hp)

	if PlayerAttr.combat.hp <= 0:
		die()

func die():
	#print("Player tumbang.")
	queue_free()

func apply_knockback(source_pos: Vector2, strength: float):
	#print("Knocked!")
	var dir = (global_position - source_pos).normalized()
	knockback_velocity = dir * strength
	is_knockback = true
	knockback_timer = knockback_time

func _physics_process(delta: float) -> void:
	PlayerAttr.effects.slowness = 0.0

	if is_knockback:
		velocity = knockback_velocity
		knockback_timer -= delta

		if knockback_timer <= 0:
			is_knockback = false

	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_pressed("ui_sneak"):
			PlayerAttr.effects.slowness = 0.75
			print("Player sedang mengendap-endap")
			
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = PlayerAttr.movement.jump * (1-PlayerAttr.effects.slowness)
		

		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * PlayerAttr.movement.speed * (1-PlayerAttr.effects.slowness)
			$AnimatedSprite2D.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, PlayerAttr.movement.speed)

	move_and_slide()
