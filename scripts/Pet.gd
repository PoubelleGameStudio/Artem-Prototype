extends AnimatedSprite2D
class_name Pet

@export var summoned: bool:
	set(value):
		summoned = value
		if summoned == true:
			show()
		else:
			hide()
