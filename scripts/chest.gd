extends Node2D
class_name LootChest

@export var item: String
@export var item_amount: int


func remove() -> void:
	queue_free()
