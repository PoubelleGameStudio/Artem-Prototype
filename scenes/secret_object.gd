extends TileMap

class_name SecretDoor

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D




func _on_secret_toggled():
	animation.play("moveWall")
	sound.play()
