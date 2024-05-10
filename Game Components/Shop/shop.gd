extends Node2D

@onready var currentGold: Label = $Sprite2D/buy/VBoxContainer/current_gold

# Called when the node enters the scene tree for the first time.
func _ready():
	currentGold.text = str(State.gold,"g")
	$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore".grab_focus()
	print(get_viewport().gui_get_focus_owner(),"_ready")

func set_focus() -> void:
	$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore".grab_focus()
	print(get_viewport().gui_get_focus_owner())
	
	
func _on_health_restore_update_gold():
	currentGold.text = str(State.gold,"g")


func _on_health_restore_2_update_gold():
	currentGold.text = str(State.gold,"g")


func _on_health_restore_3_update_gold():
	currentGold.text = str(State.gold,"g")
