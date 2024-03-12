extends CanvasLayer

@onready var player: AnimationPlayer = $AnimationPlayer
@onready var Splash: Sprite2D = $HBoxContainer/ScreenText

func change_scene(target: String) -> void:
	$AnimationPlayer.play_backwards('fade in')
	get_tree().change_scene_to_file(target)
	player.play('fade in')
	
func fade_in() -> void:
	player.play('RESET')

	
func fade_out() -> void:
	player.play_backwards('RESET')
	

func victory() -> void:
	State.can_walk = false
	Splash.texture = load("res://Art/TEXT/victory.png")
	player.play("victory")
	await get_tree().create_timer(2).timeout
	player.play_backwards("victory")
	State.can_walk = true

func death() -> void:
	State.can_walk = false
	Splash.texture = load("res://Art/TEXT/Death.png")
	player.play("death")
	await get_tree().create_timer(2).timeout
	player.play_backwards("death")
	State.can_walk = true
