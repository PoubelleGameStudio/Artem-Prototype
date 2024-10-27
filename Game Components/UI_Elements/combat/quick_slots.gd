extends Control

class_name QuickSlots

@onready var slot1 : Button = $"slot 1"
@onready var slot1_label : Label = $"slot 1/Label"
@onready var slot1_sprite : Sprite2D = $"slot 1/Sprite2D"
@onready var slot1_hovered : bool = false

@onready var slot2 : Button = $"slot 2"
@onready var slot2_label : Label = $"slot 2/Label"
@onready var slot2_sprite : Sprite2D = $"slot 2/Sprite2D"
@onready var slot2_hovered : bool = false

@onready var slot3 : Button = $"slot 3"
@onready var slot3_label : Label = $"slot 3/Label"
@onready var slot3_sprite : Sprite2D = $"slot 3/Sprite2D"
@onready var slot3_hovered : bool = false

@onready var slot4 : Button = $"slot 4"
@onready var slot4_label : Label = $"slot 4/Label"
@onready var slot4_sprite : Sprite2D = $"slot 4/Sprite2D"
@onready var slot4_hovered : bool = false

signal slot1_used
signal slot2_used
signal slot3_used
signal slot4_used

# Called when the node enters the scene tree for the first time.
func _ready():
	setup()



func _process(_delta):
	clear_quick_slot()



func setup() -> void :
	print("setting up quick slots")
	if State.quick_slot_1 and State.check_inv(State.quick_slot_1) > 0:
		slot1_label.text = State.quick_slot_1
		if State.quick_slot_1:
			slot1_sprite.texture = load(str("res://Art/inv_Art/",State.quick_slot_1,".png"))
			slot1.disabled = false
	else:
		State.quick_slot_1  = ''
		slot1_label.text = ''
		slot1_sprite.texture = null
		slot1.disabled = true
	
	if State.quick_slot_2 and State.check_inv(State.quick_slot_2) > 0:
		slot2_label.text = State.quick_slot_2
		if State.quick_slot_2 and State.check_inv(State.quick_slot_2) > 0:
			slot2_sprite.texture = load(str("res://Art/inv_Art/",State.quick_slot_2,".png"))
			slot2.disabled = false
	else:
		State.quick_slot_2  = ''
		slot2_label.text = ''
		slot2_sprite.texture = null
		slot2.disabled = true
	
	if State.quick_slot_3 and State.check_inv(State.quick_slot_3) > 0:
		slot3_label.text = State.quick_slot_3
		if State.quick_slot_3:
			slot3_sprite.texture = load(str("res://Art/inv_Art/",State.quick_slot_3,".png"))
			slot3.disabled = false
	else:
		State.quick_slot_3  = ''
		slot3_label.text = ''
		slot3_sprite.texture = null
		slot3.disabled = true
	
	if State.quick_slot_4  and State.check_inv(State.quick_slot_4) > 0:
		slot4_label.text = State.quick_slot_4
		if State.quick_slot_4:
			slot4_sprite.texture = load(str("res://Art/inv_Art/",State.quick_slot_4,".png"))
			slot4.disabled = false
	else:
		State.quick_slot_4  = ''
		slot4_label.text = ''
		slot4_sprite.texture = null
		slot4.disabled = true

func clear_quick_slot() -> void : 
	if Input.is_action_just_pressed("clear_quick_slot"):
		if slot1_hovered:
			State.quick_slot_1 = ''
			setup()
		elif slot2_hovered:
			State.quick_slot_2 = ''
			setup()
		elif slot3_hovered:
			State.quick_slot_3 = ''
			setup()
		elif slot4_hovered:
			State.quick_slot_4 = ''
			setup()

func _on_slot_1_pressed():
	slot1_used.emit()
	if State.check_inv(slot1_label.text) <= 0 :
		State.quick_slot_1 = ''
		slot1_sprite.set_texture(null)
		slot1.disabled = true


func _on_slot_1_mouse_entered():
	slot1.has_focus()
	slot1_label.show()
	slot1_hovered = true



func _on_slot_1_mouse_exited():
	slot1_label.hide()
	slot1_hovered = false



func _on_slot_1_focus_entered():
	slot1_label.show()
	slot1_hovered = true


func _on_slot_1_focus_exited():
	slot1_label.hide()
	slot1_hovered = false



func _on_slot_2_pressed():
	slot2_used.emit()
	if State.check_inv(slot2_label.text) <= 0 :
		State.quick_slot_2 = ''
		slot2_sprite.set_texture(null)
		slot2.disabled = true



func _on_slot_2_focus_entered():
	slot2_label.show()
	slot2_hovered = true
	
	

func _on_slot_2_focus_exited():
	slot2_label.hide()
	slot2_hovered = false


func _on_slot_2_mouse_entered():
	slot2.has_focus()
	slot2_label.show()
	slot2_hovered = true
	


func _on_slot_2_mouse_exited():
	slot2_label.hide()
	slot2_hovered = false



func _on_slot_3_pressed():
	slot3_used.emit()
	if State.check_inv(slot3_label.text) <= 0 :
		State.quick_slot_3 = ''
		slot3_sprite.set_texture(null)
		slot3.disabled = true

func _on_slot_3_focus_entered():
	slot3_label.show()
	slot3_hovered = true



func _on_slot_3_focus_exited():
	slot3_label.hide()
	slot3_hovered = false



func _on_slot_3_mouse_entered():
	slot2.has_focus()
	slot3_label.show()
	slot3_hovered = true



func _on_slot_3_mouse_exited():
	slot3_label.hide()
	slot3_hovered = false



func _on_slot_4_pressed():
	slot4_used.emit()
	if State.check_inv(slot4_label.text) <= 0 :
		State.quick_slot_4 = ''
		slot4_sprite.set_texture(null)
		slot4.disabled = true


func _on_slot_4_focus_entered():
	slot4_label.show()
	slot4_hovered = true



func _on_slot_4_focus_exited():
	slot4_label.hide()
	slot4_hovered = false



func _on_slot_4_mouse_entered():
	slot4.has_focus()
	slot4_label.show()
	slot4_hovered = true


func _on_slot_4_mouse_exited():
	slot4_label.hide()
	slot4_hovered = false
