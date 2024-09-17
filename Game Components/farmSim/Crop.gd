extends Node2D

@onready var crop_area: Area2D = $Area2D
@onready var crop_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var crop_name: String
@export var crop_stage: int



func _ready():
	crop_sprite.play(str(crop_name,crop_stage))

func _process(delta):
	pass

func seed_crop(crop,stage) -> void:
	crop_name = crop
	crop_stage = stage
	crop_sprite.play(str(crop_name,str(crop_stage)))

func grow_crop() -> void:
	crop_stage += 1
	crop_sprite.play(str(crop_name,str(crop_stage)))

func harvest_crop() -> void:
	State.update_inventory(crop_name,1)
	crop_name = ""
	crop_stage = 0
	crop_sprite.hide()
