@tool
extends Node2D


func _ready():
	for bug in get_tree().get_nodes_in_group("bugs"):
		bug.play("flies")
