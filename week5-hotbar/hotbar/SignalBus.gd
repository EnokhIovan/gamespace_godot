extends Node

func setupHotbarItem(hotbar):
	hotbar.get_node("Slot1/Item").play("necklace")
	hotbar.get_node("Slot3/Item").play("magicBook")

func changeSelectedItem(hotbar, index, target):
	# Reset semua border
	for child in hotbar.get_children():
		child.play("Border")

	# Slot yang dipilih
	var slot_path = "Slot%d" % index
	var slot = hotbar.get_node(slot_path)

	if slot and slot.has_node("Item"):
		slot.play("SelectedBorder")
		changeDisplay(slot.get_node("Item").animation, target)

func changeDisplay(item, display):
	display.play(item);
