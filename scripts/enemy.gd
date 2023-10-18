extends Node

@export var health = 100
@export var speed = 5
@export var enemy_type = ""
@export var emitter = 0
@export var defeated = 0
@export var world = ""

@onready var level = ""
@onready var enemySprite = $enemySprite
@onready var animation = str(enemy_type)
@onready var light = $PointLight2D
@onready var zone_fights = State.area_enemies

#signals
signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	enemySprite.play(str(enemy_type,"_idle"))
	print(enemy_type,"_idle from enemy")
	if emitter == 0:
		light.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_defeat(int):
	defeated = int

func enemyType(text):
	enemy_type = text
	
func updateHealth(damage):
	health -= damage
	if health <= 0:
		State.area_enemies[world][enemy_type] = 1
		enemySprite.play(str(enemy_type,"_death"))
		dead.emit()

		
		
		
