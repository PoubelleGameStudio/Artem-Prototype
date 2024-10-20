extends Button





func _on_focus_entered():
	$Sprite2D.show()


func _on_focus_exited():
	$Sprite2D.hide()


func _on_mouse_entered():
	$Sprite2D.show()


func _on_mouse_exited():
	$Sprite2D.hide()
