extends AudioStreamPlayer
class_name RainPlayer


func _process(_delta):
	if self.playing == false and State.mute_sound == false:
		self.playing = true
