extends CanvasLayer

var JUMP_BOOST_COOLDOWN = 4.0
var POISON_COOLDOWN = 8.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$JumpProg.max_value = JUMP_BOOST_COOLDOWN
	$JumpProg.value = JUMP_BOOST_COOLDOWN
	$SkillProg.max_value = POISON_COOLDOWN
	$SkillProg.value = POISON_COOLDOWN

func reset(node):
	node.value = 0.0;
	for i in range(node.max_value):
		await get_tree().create_timer(1.0).timeout
		node.value += 1
		if(node.value == node.max_value):
			print(node.name, " siap")
		else:
			print("Coldown ", node.name, ": ", node.max_value - node.value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
