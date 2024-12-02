extends Node2D

const Balloon = preload("res://Game Components/dialogue/balloon.tscn")

@onready var music: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3).timeout
	talk("res://Game Components/dialogue/monologue.dialogue")


func _process(delta):
	if music.playing == false:
		music.play()
	print(music.playing)

	
func talk(resource) -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.add_to_group("chats")
	balloon.set_character_label_color("d0da91")
	balloon.start(load(resource),"start")
