extends Node2D

var keys = [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5]
var hotbar_path = "Hotbar/List"

func _ready():
	SignalBus.setupHotbarItem(get_node(hotbar_path))

func _process(delta):
	for i in range(keys.size()):
		if Input.is_key_pressed(keys[i]):
			var slot_index = i + 1
			SignalBus.changeSelectedItem(get_node(hotbar_path), slot_index, get_node("Display"))
