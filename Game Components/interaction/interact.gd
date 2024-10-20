class_name Interactable extends Area2D

const Balloon = preload("res://Game Components/dialogue/balloon.tscn")

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"

@onready var balloon: Node = Balloon.instantiate()
@onready var dm = $"/root/DialogueManager"

#signal
signal value_update

func set_label(text):
	interact_label = text
	
func set_value(text):
	interact_value = text
	value_update.emit()
	
func talk(resource) -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.add_to_group("chats")
	balloon.set_character_label_color("d0da91")
	balloon.start(load(resource),"start")
	
func talk_end():
	var chats = get_tree().get_nodes_in_group("chats")
	for chat in chats:
		chat.queue_free()
