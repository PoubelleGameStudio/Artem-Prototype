extends Node

@export var health : int
@export var max_health : int
@export var speed : int = 5
@export var enemy_type : String = ''
@export var faction : String = ''
@export var emitter = 0
@export var defeated = 0
@export var world = ""
@export var id : String

@onready var level : String = ""
@onready var enemySprite : AnimatedSprite2D = $enemySprite
@onready var animation : String = str(enemy_type)
@onready var light = $PointLight2D
@onready var zone_fights = State.area_enemies
@onready var zone_enemies = State.enemies
 


 

#signals
signal dead


func _ready():
	# print("Enemy ID: ",id," ",enemy_type)
	for type in zone_enemies:
			if type == enemy_type:
				health = zone_enemies[type]["health"]
				max_health = zone_enemies[type]["health"]
				faction = zone_enemies[type]["faction"]

	if enemy_type != "":
		enemySprite.play(str(enemy_type,"_idle"))
	if emitter == 0:
		light.hide()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func enemyID(val: String):
	id = val

func set_defeat(int):
	defeated = int

func enemyType(text):
	enemy_type = text
	
func enemyHealth():
	for type in zone_enemies:
			if type == enemy_type:
				health = zone_enemies[type]["health"]
				max_health = zone_enemies[type]["health"]
	pass
	
func updateHealth(damage):
	health -= damage
	if health <= 0:
		State.area_enemies[world][id] = 1
		enemySprite.play(str(enemy_type,"_death"))
		dead.emit()

		
		
		
