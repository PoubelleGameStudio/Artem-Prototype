extends Node2D


@onready var dimmer: ColorRect = $dimmer
@onready var pause_menu = $HBoxContainer/MainMenu

@export var can_toggle_pause = true


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			pause()
			pause_menu.focus()
		else:
			resume()
			


func pause():
	$pause_text.set_text("GAME PAUSED")
	get_tree().set_deferred("paused",true)
	show()
	
	print('paused')
	
	
	

func resume():
	if can_toggle_pause:
		get_tree().set_deferred("paused",false)
		$pause_text.set_text("")
		hide()
		print('resume')
		
		

