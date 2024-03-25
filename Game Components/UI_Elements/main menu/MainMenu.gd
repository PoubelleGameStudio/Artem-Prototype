extends Control

@onready var loader = $"../../../../.."
@onready var player = $"../../../.."




const save_dir = "user://saves/"
var save_file = "PlayerSave.tres"

var playerData = PlayerData.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$"MarginContainer/VBoxContainer/New Game".grab_focus()
	verify_save_directory(save_dir)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)
	

func focus() -> void:
	$"MarginContainer/VBoxContainer/New Game".grab_focus()



func _on_new_game_pressed():
	SceneTransition.fade_out()
	get_tree().change_scene_to_file("res://scenes/levels/grimsBriar.tscn")



func _on_load_pressed():
	SceneTransition.fade_out()
	playerData = ResourceLoader.load(save_dir + save_file).duplicate(true)
	load_player()
	

func _on_save_pressed():
	save_player()
	ResourceSaver.save(playerData, save_dir + save_file)
	print(PlayerData)
	print("game saved")



func _on_options_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
	
	
# system state
func save_player()-> void:
	playerData.welcomed = State.welcomed
	playerData.prev_scene = State.prev_scene
	playerData.engaging = State.engaging
	playerData.spell1 = State.spell1
	playerData.spell2 = State.spell2
	playerData.spell3 = State.spell3
	playerData.helm = State.helm
	playerData.chest = State.chest
	playerData.gloves = State.gloves
	playerData.pants = State.pants
	playerData.boots = State.boots
	playerData.weapon = State.weapon
	playerData.health = State.health
	playerData.maxHealth = State.maxHealth
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
	$"../..".resume()
	
func load_player() -> void:
	State.welcomed = playerData.welcomed
	State.prev_scene = playerData.prev_scene
	State.engaging = playerData.engaging
	State.spell1 = playerData.spell1
	State.spell2 = playerData.spell2
	State.spell3 = playerData.spell3
	State.helm = playerData.helm
	State.chest = playerData.chest
	State.gloves = playerData.gloves
	State.pants = playerData.pants
	State.boots = playerData.boots
	State.weapon = playerData.weapon
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

	State.tutorials = playerData.tutorials
	get_tree().change_scene_to_file((str("res://scenes/levels/",playerData.world,".tscn")))
	# establish new player ref

	if get_tree().get_root().get_node("root").level_name != "title_screen":
		player.set_global_position(Vector2(playerData.pos))
		player.camera_current()
		$"../..".resume()
	print("save loaded")

func toggle_focus_mark(node) -> void:
	if node.visible:
		node.hide()
		print("node hid")
	else:
		node.show()

func _on_new_game_focus_entered():
	toggle_focus_mark($"MarginContainer/VBoxContainer/New Game/ColorRect")


func _on_new_game_focus_exited():
	toggle_focus_mark($"MarginContainer/VBoxContainer/New Game/ColorRect") # Replace with function body.


func _on_new_game_mouse_entered():
	toggle_focus_mark($"MarginContainer/VBoxContainer/New Game/ColorRect")


func _on_new_game_mouse_exited():
	toggle_focus_mark($"MarginContainer/VBoxContainer/New Game/ColorRect")
	$"MarginContainer/VBoxContainer/New Game".release_focus()


func _on_load_focus_entered():
	toggle_focus_mark($MarginContainer/VBoxContainer/Load/ColorRect2)


func _on_load_focus_exited():
	toggle_focus_mark($MarginContainer/VBoxContainer/Load/ColorRect2)


func _on_load_mouse_entered():
	toggle_focus_mark($MarginContainer/VBoxContainer/Load/ColorRect2)


func _on_load_mouse_exited():
	toggle_focus_mark($MarginContainer/VBoxContainer/Load/ColorRect2)
	$"MarginContainer/VBoxContainer/Load".release_focus()
	

func _on_save_focus_entered():
	toggle_focus_mark($MarginContainer/VBoxContainer/Save/ColorRect3)


func _on_save_focus_exited():
	toggle_focus_mark($MarginContainer/VBoxContainer/Save/ColorRect3)


func _on_save_mouse_entered():
	toggle_focus_mark($MarginContainer/VBoxContainer/Save/ColorRect3)


func _on_save_mouse_exited():
	toggle_focus_mark($MarginContainer/VBoxContainer/Save/ColorRect3)
	$"MarginContainer/VBoxContainer/Save".release_focus()


func _on_exit_mouse_entered():
	toggle_focus_mark($MarginContainer/VBoxContainer/Exit/ColorRect4)


func _on_exit_mouse_exited():
	toggle_focus_mark($MarginContainer/VBoxContainer/Exit/ColorRect4)
	$"MarginContainer/VBoxContainer/Exit".release_focus()


func _on_exit_focus_entered():
	toggle_focus_mark($MarginContainer/VBoxContainer/Exit/ColorRect4)


func _on_exit_focus_exited():
	toggle_focus_mark($MarginContainer/VBoxContainer/Exit/ColorRect4)
