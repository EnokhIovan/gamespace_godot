extends CharacterBody2D

@onready var animSprite = $AnimatedSprite2D
var slowed_targets = {}
var bodies_in_zone = []
var slowness = 0.4

func wake_up() -> void:
	animSprite.play("spawn")
	await animSprite.animation_finished
	animSprite.play("idle")

func sleep() -> void:
	animSprite.play("despawn")

func _on_slow_zone_body_entered(body):
	if body.is_in_group("player"):
		bodies_in_zone.append(body)

func _on_slow_zone_body_exited(body):
	if body.is_in_group("player"):
		if slowed_targets.has(body):
			body.PlayerAttr.movement.speed /= slowness
			slowed_targets.erase(body)

		bodies_in_zone.erase(body)
		if !Input.is_action_pressed("ui_sneak"):
			sleep()

func _process(delta: float) -> void:
	for body in bodies_in_zone:
		
		var isSneaking = Input.is_action_pressed("ui_sneak")
		var isIdle = Input.get_axis("ui_left", "ui_right") == 0

		# Player aman kalau sneak ATAU idle
		if isSneaking or isIdle:
			continue

		# Player ketahuan hanya kalau ga sneak & ga idle
		if not slowed_targets.has(body):
			wake_up()
			print("Terkena efek slow")
			slowed_targets[body] = true
			body.PlayerAttr.movement.speed *= slowness
