extends Node2D


@export var energy = 1
@export var model = ""


@onready var light = $PointLight2D
@onready var interact = $torch_interact
@onready var rot_value = float(interact.interact_value)
@onready var sprite = $Sprite2D

@onready var tilemap = get_tree().get_root().get_node("root/TileMap")


# Called when the node enters the scene tree for the first time.
func _ready():
	light.energy = energy
	sprite.set_texture(load(str("res://Sprites/world objects/lights/",model,".png")))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_torch_interact_value_update():
	sprite.rotate(0)
	tilemap.clear_layer(1)
