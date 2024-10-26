extends Control

class_name QuickSlots

@onready var slot1 : Button = $"slot 1"
@onready var slot1_label : Label = $"slot 1/Label"
@onready var slot1_sprite : Sprite2D = $"slot 1/Sprite2D"

@onready var slot2 : Button = $"slot 2"
@onready var slot2_label : Label = $"slot 2/Label"
@onready var slot2_sprite : Sprite2D = $"slot 2/Sprite2D"

@onready var slot3 : Button = $"slot 3"
@onready var slot3_label : Label = $"slot 3/Label"
@onready var slot3_sprite : Sprite2D = $"slot 3/Sprite2D"

@onready var slot4 : Button = $"slot 4"
@onready var slot4_label : Label = $"slot 4/Label"
@onready var slot4_sprite : Sprite2D = $"slot 4/Sprite2D"

signal slot1_used
signal slot2_used
signal slot3_used
signal slot4_used

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()


func setup() -> void :
	if State.quick_slot_1:
		slot1_label.text = State.quick_slot_1
		if State.quick_slot_1:
			slot1_sprite.texture = load(str("res://Art/inv_Art/",State.quick_slot_1,".png"))
	#else:
		#slot1.disabled = true
	
	if State.quick_slot_2:
		slot2_label.text = State.quick_slot_2
		if State.quick_slot_2:
			slot2_sprite.texture = load(str("res://Art/inv_Art/",State.quick_slot_2,".png"))
	#else:
		#slot2.disabled = true
	
	if State.quick_slot_3:
		slot3_label.text = State.quick_slot_3
		if State.quick_slot_3:
			slot3_sprite.texture = load(str("res://Art/inv_Art/",State.quick_slot_3,".png"))
	#else:
		#slot3.disabled = true
	
	if State.quick_slot_4:
		slot4_label.text = State.quick_slot_4
		if State.quick_slot_4:
			slot4_sprite.texture = load(str("res://Art/inv_Art/",State.quick_slot_4,".png"))


func _on_slot_1_pressed():
	print("slot1")
	slot1_used.emit()
	if State.check_inv(slot1_label.text) <= 0 :
		State.quick_slot_1 = ''
		slot1.set_texture(null)


func _on_slot_1_mouse_entered():
	slot1_label.show()



func _on_slot_1_mouse_exited():
	slot1_label.hide()



func _on_slot_1_focus_entered():
	slot1_label.show()


func _on_slot_1_focus_exited():
	slot1_label.hide()



func _on_slot_2_pressed():
	slot2_used.emit()



func _on_slot_2_focus_entered():
	slot2_label.show()
	
	

func _on_slot_2_focus_exited():
	slot2_label.hide()


func _on_slot_2_mouse_entered():
	slot2_label.show()
	


func _on_slot_2_mouse_exited():
	slot2_label.hide()



func _on_slot_3_pressed():
	slot3_used.emit()


func _on_slot_3_focus_entered():
	slot3_label.show()



func _on_slot_3_focus_exited():
	slot3_label.hide()



func _on_slot_3_mouse_entered():
	slot3_label.show()



func _on_slot_3_mouse_exited():
	slot3_label.hide()



func _on_slot_4_pressed():
	slot4_used.emit()



func _on_slot_4_focus_entered():
	slot4_label.show()



func _on_slot_4_focus_exited():
	slot4_label.hide()



func _on_slot_4_mouse_entered():
	slot4_label.show()



func _on_slot_4_mouse_exited():
	slot4_label.hide()
