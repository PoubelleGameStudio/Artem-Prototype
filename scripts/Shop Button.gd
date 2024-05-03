extends Control
class_name ShopButton

@export var item_name: String
@export var item_cost: int

@onready var button: Button = $Button
@onready var label: Label = $Label
@onready var UI_click: AudioStreamPlayer = $UI_click
@onready var UI_purchase: AudioStreamPlayer = $UI_purchase

# signal
signal updateGold


# Called when the node enters the scene tree for the first time.
func _ready():
	button.icon = load(str("res://Art/inv_Art/",item_name,".png"))
	label.text = str(item_cost," g")


func _on_button_pressed():
	if State.gold >= item_cost:
		#play purchase sound
		UI_purchase.play()
		#subtract gold
		State.gold -= item_cost
		updateGold.emit()
		#add item
		State.update_inventory(item_name,1)
	else:
		pass
		#play poor sound


func _on_button_mouse_entered():
	UI_click.play()
	#play tick kinda sound
