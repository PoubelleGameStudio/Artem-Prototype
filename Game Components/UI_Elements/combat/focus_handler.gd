extends Button





func _on_focus_entered():
	$Sprite2D.show()


func _on_focus_exited():
	$Sprite2D.hide()
