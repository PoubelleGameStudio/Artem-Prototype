extends Node2D
class_name LevelManager

@onready var music = $AudioStreamPlayer
@onready var c_music: AudioStreamPlayer = AudioStreamPlayer.new()
@export var is_raining: int 
@export var level_name: String
@onready var combat = $combatScreen
@onready var enemy_list = State.area_enemies[level_name]
@onready var player = $player
@onready var respawn_location = $respawn.global_position



# Called when the node enters the scene tree for the first time.
func _ready():
	
	#signal
	music.finished.connect(_on_music_finished)

	if level_name != "title_screen":
		SceneTransition.fade_in()

	if State.p_locs.has(level_name):
		get_node("player").global_position = State.p_locs[level_name]

	State.is_raining = is_raining
	State.world = level_name


	add_child(c_music)
	c_music.stream = load("res://sounds/levelMusic/to battle so that we may die.wav")
	c_music.volume_db = 0
	c_music.set_bus("Effects")
	
	player.camera_current()
	
	if combat:
		combat.process_mode = 4
		player.world = level_name
		
	bury_the_dead()	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if State.combat && !c_music.playing:
		c_music.play()

	# makes sure music isn't playing when in dialogue
	if State.mute_sound == false && State.talking == 1:
		music.volume_db = -15
	else:
		music.volume_db = 0



func _on_music_finished():
	music.play()

########### checks that save directory exists###########
func verify_save_directory(path:String):
	DirAccess.make_dir_absolute(path)


func bury_the_dead():
	var to_kill = get_tree().get_nodes_in_group("enemies")
	print("checking for bodies")
	for bad in to_kill:
		if State.area_enemies[level_name][bad.id] == 1:
			bad.remove_from_group("enemies")
			bad.hide()
			bad.process_mode = 4


func setup_combat():
	combat.show()
	combat.process_mode = 0
	music.playing = false
	combat.start_turn()


func stop_combat():
	combat.hide()
	combat.process_mode = 4
	bury_the_dead()
	music.playing = true


func _on_combat_screen_combat_end():
	enemy_list[State.engaging] = 1
	var hide_node = NodePath(str("enemies/",State.engaging[0]))
	SceneTransition.victory()
	stop_combat()
	State.talking = 0
	combat.endgame()
	player.camera_current()
	State.combat = false
	State.level_up()
	music.playing = true
	c_music.playing = false


func _on_player_combat_entered():
	combat.casts_left = State.casts
	if State.combat == false:
		c_music.playing = true
		music.playing = false
		setup_combat()
		combat.combat_data()
		combat.camera_current()


func _on_combat_screen_death():
	SceneTransition.death()
	c_music.playing = false
	stop_combat()
	State.health = State.maxHealth
	player.camera_current()
	player.global_position = respawn_location
	State.combat = false
	music.playing = true
	



func _on_audio_stream_player_finished():
	pass # Replace with function body.
