extends Control

@onready var loader = get_node('/root/root')
@onready var player = get_node_or_null('/root/root/player') 


@onready var confirm: AudioStream = preload("res://sounds/UI/movement_1.wav")
@onready var focus_sound: AudioStream = preload("res://sounds/UI/block_1.wav")
@onready var sound: AudioStreamPlayer = $AudioStreamPlayer



const save_dir = "user://saves/"
var save_file = "PlayerSave.tres"

var playerData = PlayerData.new()
var settingsConfig = SettingsConfig.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_dir)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	

func set_focus() -> void:
	$MarginContainer/VBoxContainer/Load.grab_focus()



func _on_new_game_pressed():
	sound.set_stream(confirm)
	sound.play()
	SceneTransition.fade_out()
	get_tree().change_scene_to_file("res://scenes/levels/grimsBriar.tscn")



func _on_load_pressed():
	sound.set_stream(confirm)
	sound.play()
	SceneTransition.fade_out()
	playerData = ResourceLoader.load(save_dir + save_file).duplicate(true)
	load_player()
	

func _on_save_pressed():
	sound.set_stream(confirm)
	sound.play()
	save_player()
	ResourceSaver.save(playerData, save_dir + save_file)
	print(PlayerData)
	print("game saved")


func _on_exit_pressed():
	sound.set_stream(confirm)
	sound.play()
	get_tree().quit()
	pass # Replace with function body.
	
	
# system state
func save_player()-> void:
	State.p_locs[loader.level_name] = player.global_position
	playerData.welcomed = State.welcomed
	playerData.prev_scene = State.prev_scene
	playerData.engaging = State.engaging
	playerData.spell1 = State.spell1
	playerData.spell2 = State.spell2
	playerData.spell3 = State.spell3
	playerData.spell4 = State.spell4
	playerData.spell5 = State.spell5
	playerData.spell6 = State.spell6
	playerData.quick_slot_1 = State.quick_slot_1
	playerData.quick_slot_2 = State.quick_slot_2
	playerData.quick_slot_3 = State.quick_slot_3
	playerData.quick_slot_4 = State.quick_slot_4
	#playerData.helm = State.helm
	#playerData.chest = State.chest
	#playerData.gloves = State.gloves
	#playerData.pants = State.pants
	#playerData.boots = State.boots
	#playerData.weapon = State.weapon
	playerData.health = State.health
	playerData.maxHealth = State.maxHealth
	playerData.bonusMaxHealth = State.bonusMaxHealth
	playerData.baseMaxHealth = State.baseMaxHealth
	playerData.cur_xp = State.cur_xp
	playerData.xp_to_next = State.xp_to_next
	playerData.level = State.level
	playerData.armor = State.armor
	playerData.crit_chance = State.crit_chance
	playerData.rFire = State.rFire
	playerData.rFrost = State.rFrost
	playerData.rArcane = State.rArcane
	playerData.rBlood = State.rBlood
	playerData.rVoid = State.rVoid
	playerData.gold = State.gold
	playerData.player_inv = State.inventory
	playerData.quest_db = State.quest_db 
	playerData.area_enemies = State.area_enemies
	playerData.Vendor_wares = State.Vendor_wares
	playerData.tutorials = State.tutorials
	playerData.t_HP = State.t_HP
	playerData.t_attack_up = State.t_attack_up
	playerData.t_extra_cast = State.t_extra_cast
	playerData.t_shield = State.t_shield
	playerData.t_kindling = State.t_kindling
	playerData.t_curse = State.t_curse
	playerData.t_poison_swamp = State.t_poison_swamp
	playerData.t_hollowed_threats = State.t_hollowed_threats
	playerData.t_void_sight = State.t_void_sight
	playerData.t_vapid_affliction = State.t_vapid_affliction
	playerData.t_sanguinated_shell = State.t_sanguinated_shell
	playerData.t_blood_clot_homunculus = State.t_blood_clot_homunculus
	playerData.t_blood_moon = State.t_blood_moon
	playerData.world = loader.level_name
	playerData.pos = player.get_global_position()
	playerData.met_stw = State.met_stw
	
func load_player() -> void:
	State.welcomed = playerData.welcomed
	State.prev_scene = playerData.prev_scene
	State.engaging = playerData.engaging
	State.spell1 = playerData.spell1
	State.spell2 = playerData.spell2
	State.spell3 = playerData.spell3
	State.spell4 = playerData.spell4
	State.spell5 = playerData.spell5
	State.spell6 = playerData.spell6
	State.quick_slot_1 = playerData.quick_slot_1
	State.quick_slot_2 = playerData.quick_slot_2
	State.quick_slot_3 = playerData.quick_slot_3
	State.quick_slot_4 = playerData.quick_slot_4
	#State.helm = playerData.helm
	#State.chest = playerData.chest
	#State.gloves = playerData.gloves
	#State.pants = playerData.pants
	#State.boots = playerData.boots
	#State.weapon = playerData.weapon
	State.health = playerData.health
	State.maxHealth = playerData.maxHealth
	State.bonusMaxHealth = playerData.bonusMaxHealth
	State.baseMaxHealth = playerData.baseMaxHealth
	State.cur_xp = playerData.cur_xp
	State.xp_to_next = playerData.xp_to_next
	State.level = playerData.level
	State.armor = playerData.armor
	State.crit_chance = playerData.crit_chance
	State.rFire = playerData.rFire
	State.rFrost = playerData.rFrost
	State.rArcane = playerData.rArcane
	State.rBlood = playerData.rBlood
	State.rVoid = playerData.rVoid
	State.gold = playerData.gold
	State.t_HP = playerData.t_HP
	State.t_attack_up = playerData.t_attack_up
	State.t_extra_cast = playerData.t_extra_cast
	State.t_shield = playerData.t_shield
	State.t_kindling = playerData.t_kindling
	State.t_curse = playerData.t_curse
	State.t_poison_swamp = playerData.t_poison_swamp
	State.t_hollowed_threats = playerData.t_hollowed_threats
	State.t_void_sight = playerData.t_void_sight
	State.t_vapid_affliction = playerData.t_vapid_affliction
	State.t_sanguinated_shell = playerData.t_sanguinated_shell
	State.t_blood_clot_homunculus = playerData.t_blood_clot_homunculus
	State.t_blood_moon = playerData.t_blood_moon
	State.inventory = playerData.player_inv
	State.quest_db = playerData.quest_db 
	State.area_enemies = playerData.area_enemies
	State.Vendor_wares = playerData.Vendor_wares
	State.talking = 0
	State.combat = false
	State.met_stw = playerData.met_stw

	State.tutorials = playerData.tutorials
	get_tree().change_scene_to_file((str("res://scenes/levels/",playerData.world,".tscn")))

	if loader.level_name != "title_screen":
		if State.p_locs.has(loader.level_name):
			player.global_position = State.p_locs[loader.level_name]
		player.camera_current()


func toggle_focus_mark(node) -> void:
	pass
	#if node.visible:
		#node.hide()
	#else:
		#node.show()

func _on_new_game_focus_entered():
	sound.set_stream(focus_sound)
	sound.play()
	toggle_focus_mark($"MarginContainer/VBoxContainer/New Game/ColorRect")


func _on_new_game_focus_exited():
	toggle_focus_mark($"MarginContainer/VBoxContainer/New Game/ColorRect")


func _on_new_game_mouse_entered():
	sound.set_stream(focus_sound)
	sound.play()
	$"MarginContainer/VBoxContainer/New Game/Label".set("theme_override_colors/font_color", Color.WHITE)


func _on_new_game_mouse_exited():
	$MarginContainer/VBoxContainer/Load/Label.set("theme_override_colors/font_color", Color.BLACK)
	$"MarginContainer/VBoxContainer/New Game".release_focus()


func _on_load_focus_entered():
	sound.set_stream(focus_sound)
	sound.play()
	$MarginContainer/VBoxContainer/Load/Label2.set("theme_override_colors/font_color", Color.WHITE)


func _on_load_focus_exited():
	$MarginContainer/VBoxContainer/Load/Label2.set("theme_override_colors/font_color", Color.BLACK)


func _on_load_mouse_entered():
	sound.set_stream(focus_sound)
	sound.play()
	$MarginContainer/VBoxContainer/Load/Label2.set("theme_override_colors/font_color", Color.WHITE) #toggle_focus_mark($MarginContainer/VBoxContainer/Load/ColorRect2)


func _on_load_mouse_exited():
	toggle_focus_mark($MarginContainer/VBoxContainer/Load/ColorRect2)
	$"MarginContainer/VBoxContainer/Load".release_focus()
	$MarginContainer/VBoxContainer/Load/Label2.set("theme_override_colors/font_color", Color.BLACK)
	

func _on_save_focus_entered():
	sound.set_stream(focus_sound)
	sound.play()
	$MarginContainer/VBoxContainer/Save/Label.set("theme_override_colors/font_color", Color.WHITE)


func _on_save_focus_exited():
	$MarginContainer/VBoxContainer/Save/Label.set("theme_override_colors/font_color", Color.BLACK)


func _on_save_mouse_entered():
	sound.set_stream(focus_sound)
	sound.play()
	$MarginContainer/VBoxContainer/Save/Label.set("theme_override_colors/font_color", Color.WHITE)


func _on_save_mouse_exited():
	$MarginContainer/VBoxContainer/Save/Label.set("theme_override_colors/font_color", Color.BLACK)
	$"MarginContainer/VBoxContainer/Save".release_focus()


func _on_exit_mouse_entered():
	sound.set_stream(focus_sound)
	sound.play()
	$MarginContainer/VBoxContainer/Exit/Label2.set("theme_override_colors/font_color", Color.WHITE)


func _on_exit_mouse_exited():
	$MarginContainer/VBoxContainer/Exit/Label2.set("theme_override_colors/font_color", Color.BLACK)
	$"MarginContainer/VBoxContainer/Exit".release_focus()


func _on_exit_focus_entered():
	sound.set_stream(focus_sound)
	sound.play()
	$MarginContainer/VBoxContainer/Exit/Label2.set("theme_override_colors/font_color", Color.WHITE)


func _on_exit_focus_exited():
	$MarginContainer/VBoxContainer/Exit/Label2.set("theme_override_colors/font_color", Color.WHITE)
