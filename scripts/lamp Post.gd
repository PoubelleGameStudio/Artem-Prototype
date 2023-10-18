extends Node2D


@export var energy = 1
@export var model = ""


@onready var light = $PointLight2D



# Called when the node enters the scene tree for the first time.
func _ready():
	light.energy = energy
	$Sprite2D.set_texture(load(str("res://Sprites/world objects/lights/",model,".png")))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass
