extends Control



@onready var capacity = 21

#signal
signal item_used

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_grid()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func populate_grid():
	# print("populating inventory")
	var inv = State.inventory
	var slots = get_node("grid").get_children()
	var current_inv = inv.keys()
	var step = 0
	for item in current_inv:
		slots[step].item_name = item
		slots[step].amount = inv[item]
		step += 1
	$grid/Slot1.grab_focus()

		
			


func _on_slot_1_item_used():
	if State.can_use:
		item_used.emit() # Replace with function body.


func _on_slot_2_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_3_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_4_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_5_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_6_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_7_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_8_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_9_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_10_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_11_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_12_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_13_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_14_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_15_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_16_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_17_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_18_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_19_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_20_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.


func _on_slot_21_item_used():
	if State.can_use:
		item_used.emit()  # Replace with function body.
