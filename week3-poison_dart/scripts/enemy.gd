extends CharacterBody2D

@onready var health_bar = $HealthBar
@onready var anim = $AnimatedSprite2D

var max_hp = 100
var hp = 100

func _ready():
	health_bar.max_value = max_hp
	health_bar.value = hp

func _process(delta):
	if anim.frame == anim.sprite_frames.get_frame_count(anim.animation) - 1:
		anim.play("idle")  # ganti anim lain

func take_damage(dmg, continousDmg):
	var conDmg = continousDmg.get("damage", 0)
	var conDelay = continousDmg.get("delay", 0)
	var conCount = continousDmg.get("count", 3)
	
	hp -= dmg
	updateHp(hp)
	
	if conDmg and conDelay:
		for i in range(conCount):
			if hp > 0:
				await get_tree().create_timer(float(conDelay)).timeout
				hp -= conDmg
				updateHp(hp)
	
	hp = max(hp, 0)
	
	
	if hp <= 0:
		die()

func updateHp(hp):
	health_bar.value = hp;
	$AnimatedSprite2D.play('damaged')

func die():
	queue_free()
