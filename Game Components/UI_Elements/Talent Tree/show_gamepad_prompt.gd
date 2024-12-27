extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	display() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	display()


func display() -> void:
	if State.control_schema == "gamepad":
		show()
	elif State.control_schema == "mkb":
		hide()
