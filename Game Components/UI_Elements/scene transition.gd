extends CanvasLayer

@onready var player: AnimationPlayer = $AnimationPlayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play_backwards('fade in')
	get_tree().change_scene_to_file(target)
	player.play('fade in')
	
func fade_in() -> void:
	player.play('RESET')

	
func fade_out() -> void:
	player.play_backwards('RESET')

