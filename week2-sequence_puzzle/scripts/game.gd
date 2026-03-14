extends Node2D

# Buttons variables
var btnCount
var pzlColList = []
var answeredPzlList = []
var answeredSttList = []

# LEDP variables
@onready var ledps = [
	$LEDPs/ledp1,
	$LEDPs/ledp2,
	$LEDPs/ledp3,
	$LEDPs/ledp4
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var colorList = ["red", "green", "blue", "yellow"]
	
	# Create a random color
	while pzlColList.size() < 4:
		var i = colorList[randi() % 4]
		if i not in pzlColList:
			pzlColList.append(i)
			ledps[pzlColList.size()-1].animation = i
			
	print("Randomized clr: ", pzlColList, "\n")
	
	
	# Detect signal when button clicked
	for btn in $Buttons.get_children():
		btn.connect("btn_pressed", _on_btn_pressed)
	
	# Count buttons
	btnCount = $Buttons.get_child_count()

func answeredStausCheck(arr):
	for stat in answeredSttList:
		if stat != 1:
			return false
	return true

func _on_btn_pressed(color):
	answeredPzlList.append(color)
	if answeredPzlList[answeredPzlList.size()-1] == pzlColList[answeredPzlList.size()-1]:
		answeredSttList.append(1)
	else:
		answeredSttList.append(0)
	print("Randomized clr: ", pzlColList)
	print("Answered clr: ", answeredPzlList)
	print("Answered stat: ", answeredSttList, "\n")
	
	if(answeredPzlList.size() == btnCount):
		if answeredStausCheck(answeredSttList):
			print("Selamat, anda berhasil menyelesaikan puzzle!")
			$platform/AnimationPlayer.play("go_down")
		else:
			print("Yah, sayang sekali, anda belum menyelesaian puzzle dengan benar.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
