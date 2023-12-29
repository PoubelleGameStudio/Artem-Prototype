extends Node2D

@onready var music = $AudioStreamPlayer
@export var is_raining: int 
@export var level_name: String

@onready var combat = $combatScreen
@onready var enemy_list = State.area_enemies[level_name]
@onready var player = $player


# Called when the node enters the scene tree for the first time.
func _ready():
	if State.p_locs.has(level_name):
			get_node("player").global_position = State.p_locs[level_name]
	State.is_raining = is_raining
	#combat.hide()

	if combat:
		combat.process_mode = 4
		player.world = level_name
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if music.playing == false:
		music.playing = true
	bury_the_dead()
		
	
func bury_the_dead():
	var to_kill = get_tree().get_nodes_in_group("enemies")
	for bad in to_kill:
		if State.area_enemies[level_name][bad.enemy_type] == 1:
			bad.remove_from_group("enemies")
			bad.hide()
			bad.process_mode = 4
		else:
			pass

			
func setup_combat():
	combat.show()
	combat.process_mode = 0


func stop_combat():
	combat.hide()
	combat.process_mode = 4
	
	


func _on_combat_screen_combat_end():
	print("combat ending")
	enemy_list[State.engaging] = 1
	var hide_node = NodePath(str("enemies/",State.engaging[0]))
	stop_combat()
	State.talking = 0
	combat.endgame()
	player.camera_current()
	pass # Replace with function body.


func _on_player_combat_entered():
	if State.combat == 0:
		setup_combat()
		combat.combat_data()
		combat.camera_current()


func _on_combat_screen_death():
	pass
