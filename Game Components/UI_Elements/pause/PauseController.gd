extends Node2D


@onready var dimmer: ColorRect = $dimmer
@onready var pause_menu = $MainMenu

@export var can_toggle_pause = true


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			pause()
		else:
			resume()
			


func pause():
	$pause_text.set_text("GAME PAUSED")
	get_tree().set_deferred("paused",true)
	dimmer.show()
	pause_menu.show()
	print('paused')
	
	
	

func resume():
	if can_toggle_pause:
		get_tree().set_deferred("paused",false)
		$pause_text.set_text("")
		dimmer.hide()
		pause_menu.hide()
		print('resume')
		
		

