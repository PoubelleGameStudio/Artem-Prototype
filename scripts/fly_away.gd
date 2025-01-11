extends Node2D

@onready var player: AnimationPlayer = $FlyAway/AnimationPlayer
@onready var trigger: Area2D = $trigger
@onready var spritePlayer: AnimatedSprite2D = $FlyAway

@export var type: String 

# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = randi_range(0,4)
	print(rand)
	await get_tree().create_timer(rand).timeout
	spritePlayer.play(str(type,"_idle"))


func fly() -> void:
	player.play("fly")
	spritePlayer.play(str(type,"_fly"))
	print("testing fly away trigger")
