extends Node2D

@onready var currentGold: Label = $Sprite2D/buy/VBoxContainer/current_gold

# Called when the node enters the scene tree for the first time.
func _ready():
	currentGold.text = str(State.gold,"g")



func _on_health_restore_update_gold():
	currentGold.text = str(State.gold,"g")


func _on_health_restore_2_update_gold():
	currentGold.text = str(State.gold,"g")


func _on_health_restore_3_update_gold():
	currentGold.text = str(State.gold,"g")
