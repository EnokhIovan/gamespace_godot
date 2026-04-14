extends Area2D

@onready var PassiveControll = get_tree().get_root().get_node("Node2D/Character/CharacterPasif")
@onready var slash = $Slash
var facing_left := false
var alr_damaged := false
var skillStat
var damageContinousCharacter = {}

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	monitoring = false

func _on_body_entered(body):
	if not monitoring:
		return

	if body.is_in_group("enemy"):
		#print(body)
		if body.has_method("take_damage") and !alr_damaged:
			if(skillStat == 1.0):
				damageContinousCharacter = {
					"damage": 3,
					"delay": 1,
					"count": 4
				}
				PassiveControll.reset(PassiveControll.get_node("SkillProg"))
			body.take_damage(10, damageContinousCharacter)
			damageContinousCharacter = {}
			alr_damaged = true

func _process(delta):
	# cuma ketika anim sedang slash
	if slash.animation == "slash" and slash.frame == 3:
		monitoring = true
	
	# update real-time status pasif skill Poison
	skillStat = PassiveControll.get_node("SkillProg").value / PassiveControll.get_node("SkillProg").max_value

func update_direction(is_left: bool):
	facing_left = is_left
	scale.x = -1 if is_left else 1

func start_slash():
	slash.visible = true
	slash.play("slash")

	monitoring = true
	await slash.animation_finished
	monitoring = false
	
	alr_damaged = false
	slash.play("blank")
	slash.visible = false
