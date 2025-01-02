extends Node2D

@onready var currentGold: Label = $Sprite2D/buy/VBoxContainer/current_gold

@onready var item_name: Label = $Sprite2D/buy/item_name
@onready var item_desc: Label = $Sprite2D/buy/item_description

signal exit

# Called when the node enters the scene tree for the first time.
func _ready():
	currentGold.text = str(State.gold,"g")

func set_focus() -> void:
	$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore".grab_focus()
	print(get_viewport().gui_get_focus_owner(),"shop focus")
	
	
func doorbell() -> void:
	$AudioStreamPlayer.play()
	
func _on_health_restore_update_gold():
	currentGold.text = str(State.gold,"g")


func _on_health_restore_2_update_gold():
	currentGold.text = str(State.gold,"g")


func _on_health_restore_3_update_gold():
	currentGold.text = str(State.gold,"g")


func _on_health_restore_focus_entered():
	item_name.text = str($"Sprite2D/buy/VBoxContainer/GridContainer/Health restore".item_name)
	item_desc.text = str("Use: ",$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore".item_desc)

func _on_health_restore_mouse_entered():
	$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore".grab_focus()
	item_name.text = str($"Sprite2D/buy/VBoxContainer/GridContainer/Health restore".item_name)
	item_desc.text = str("Use: ",$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore".item_desc)
	


func _on_health_restore_2_focus_entered():
	item_name.text = str($"Sprite2D/buy/VBoxContainer/GridContainer/Health restore2".item_name)
	item_desc.text = str("Use: ",$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore2".item_desc)


func _on_health_restore_2_mouse_entered():
	$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore2".grab_focus()
	item_name.text = str($"Sprite2D/buy/VBoxContainer/GridContainer/Health restore2".item_name)
	item_desc.text = str("Use: ",$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore2".item_desc)


func _on_health_restore_3_focus_entered():
	item_name.text = str($"Sprite2D/buy/VBoxContainer/GridContainer/Health restore3".item_name)
	item_desc.text = str("Use: ",$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore3".item_desc)


func _on_health_restore_3_mouse_entered():
	$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore3".grab_focus()
	item_name.text = str($"Sprite2D/buy/VBoxContainer/GridContainer/Health restore3".item_name)
	item_desc.text = str("Use: ",$"Sprite2D/buy/VBoxContainer/GridContainer/Health restore3".item_desc)


func _on_ripd_cd_update_gold():
	currentGold.text = str(State.gold,"g")


func _on_ripd_cd_mouse_entered():
	$"Sprite2D/buy/VBoxContainer/GridContainer/ripd_cd".grab_focus()
	item_name.text = str($"Sprite2D/buy/VBoxContainer/GridContainer/ripd_cd".item_name)
	item_desc.text = str("Use: ",$"Sprite2D/buy/VBoxContainer/GridContainer/ripd_cd".item_desc)


func _on_button_pressed():
	exit.emit()
	print("leave shop")


func _on_coffin_nails_mouse_entered():
	$Sprite2D/buy/VBoxContainer/GridContainer/coffin_nails.grab_focus()
	item_name.text = str($Sprite2D/buy/VBoxContainer/GridContainer/coffin_nails.item_name)
	item_desc.text = str("Use: ",$Sprite2D/buy/VBoxContainer/GridContainer/coffin_nails.item_desc)
