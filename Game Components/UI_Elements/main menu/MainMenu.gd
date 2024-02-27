extends Control

@onready var loader = $"../../../.."
@onready var player = $"../../.."




const save_dir = "user://saves/"
var save_file = "PlayerSave.tres"

var playerData = PlayerData.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_dir)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/grimsBriar.tscn")



func _on_load_pressed():
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
	playerData.talents = State.talents
	playerData.tutorials = State.tutorials
	playerData.world = loader.level_name
	playerData.pos = player.get_global_position()
	get_parent().resume()
	
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
	State.inventory = playerData.player_inv
	State.quest_db = playerData.quest_db 
	State.area_enemies = playerData.area_enemies
	State.Vendor_wares = playerData.Vendor_wares
	State.talents = playerData.talents
	State.tutorials = playerData.tutorials
	get_tree().change_scene_to_file((str("res://scenes/levels/",playerData.world,".tscn")))
	# establish new player ref
	var player = $"../../.."
	if get_tree().get_root().get_node("root").level_name != "title_screen":
		player.set_global_position(Vector2(playerData.pos))
		player.camera_current()
		get_parent().resume()
	print("save loaded")

