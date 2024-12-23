extends CanvasLayer

@onready var player: AnimationPlayer = $AnimationPlayer
@onready var Splash: Sprite2D = $Control/HBoxContainer/ScreenText
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

#scoreboard fields
@onready var defeated: Label = $"Control/Win Screen/Enemy_name"
@onready var loot: Label = $"Control/Win Screen/Loot"
@onready var xp: Label = $"Control/Win Screen/xp"

#pack scenes
@onready var grimsBriar = load("res://scenes/levels/grimsBriar.tscn")
@onready var GB_tavern = load("res://scenes/levels/GB_tavern.tscn")
@onready var GB_inn = load("res://scenes/levels/GB_inn.tscn")
@onready var GB_sewers = load("res://scenes/levels/GB_sewers.tscn")
@onready var WitchForest = load("res://scenes/levels/WitchForest.tscn")
@onready var forest_cave = load("res://scenes/levels/forest_cave.tscn")
@onready var energy_temple = load("res://scenes/levels/energy_temple.tscn")
@onready var mourningFields = load("res://scenes/levels/mourningFields.tscn")

signal animation_finished

func change_scene(target: String) -> void:
	
	match target :
		"grimsBriar": get_tree().change_scene_to_packed(grimsBriar)
		"GB_inn": get_tree().change_scene_to_packed(GB_inn)
		"GB_tavern": get_tree().change_scene_to_packed(GB_tavern)
		"GB_sewers": get_tree().change_scene_to_packed(GB_sewers)
		"WitchForest": get_tree().change_scene_to_packed(WitchForest)
		"forest_cave": get_tree().change_scene_to_packed(forest_cave)
		"energy_temple": get_tree().change_scene_to_packed(energy_temple)
		"mourningFields": get_tree().change_scene_to_packed(mourningFields)
	print("loading ",target)
	player.play('fade in')
	
	
func fade_in() -> void:
	player.play('fade in')

	
func fade_out() -> void:
	print("fading out")
	player.play_backwards('fade in')
	
func play_audio(track) -> void:
	audio.set_stream(track)
	audio.play()

func victory() -> void:
	State.can_walk = false
	Splash.texture = load("res://Art/TEXT/victory.png")
	load_scoreboard()
	player.play("victory")
	State.can_walk = true

func load_scoreboard() -> void:
	defeated.text = State.last_enemy_defeated["name"]
	loot.text = State.last_enemy_defeated["loot"]
	xp.text = State.last_enemy_defeated["xp_gained"]

func death() -> void:
	State.can_walk = false
	Splash.texture = load("res://Art/TEXT/Death.png")
	player.play("death")
	await get_tree().create_timer(2).timeout
	player.play_backwards("death")
	State.can_walk = true


func _on_animation_player_animation_finished():
	animation_finished.emit()
	print("animation_finished")
	
