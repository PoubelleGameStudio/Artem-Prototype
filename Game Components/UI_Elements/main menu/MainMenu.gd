extends Control

@onready var loader = $"../../../.."
@onready var player = $"../../.."



const player_data = "res://scripts/State.gd"
const security_key = "test"
const save_dir = "user://saves/"
var save_file = "save.game"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/grimsBriar.tscn")
	pass # Replace with function body.


func _on_load_pressed():
	load_data(str(save_dir,save_file))
	pass # Replace with function body.
	

func _on_save_pressed():
	save_game(str(save_dir,save_file))
	print("game saved")



func _on_options_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
	
	
# system state
func save_game(path : String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	print(file)
	if file == null:
		print(FileAccess.get_open_error())

	
	var data = {
		"player_data":{
			"welcomed":State.welcomed,
			"prev_player_position":State.prev_player_position,
			"prev_scene":State.prev_scene,
			"engaging":State.engaging,
			"spell1":State.spell1,
			"spell2":State.spell2,
			"spell3":State.spell3,
			"helm":State.helm,
			"chest":State.chest,
			"gloves":State.gloves,
			"pants":State.pants,
			"boots":State.boots,
			"weapon":State.weapon,
			"health":State.health,
			"maxHealth":State.maxHealth,
			"cur_xp":State.cur_xp,
			"xp_to_next":State.xp_to_next,
			"level":State.level,
			"armor":State.armor,
			"crit_chance":State.crit_chance,
			"rFire":State.rFire,
			"rFrost":State.rFrost,
			"rArcane":State.rArcane,
			"rBlood":State.rBlood,
			"rVoid":State.rVoid,
			"gold":State.gold,
			"player_inv":State.inventory,
			"quest_db":State.quest_db,
			"area_enemies":State.area_enemies,
			"Vendor_wares":State.Vendor_wares,
			"player_talents":State.talents,
			"world":player.get_world(),
			"player_position_x":player.get_position().x,
			"player_position_y":player.get_position().y
		}
	}
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	print(float(player.get_global_position().x)," ",float(player.get_global_position().y))
	
func load_data(path:String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file == null:
			print("file null")
			return
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("cant parse file as a json string: %s" % [data])
			return
		
		State.welcomed = data.player_data.welcomed
		State.health = data.player_data.health
		State.prev_player_position = data.player_data.prev_player_position
		State.prev_scene = data.player_data.prev_scene
		State.engaging = data.player_data.engaging
		State.spell1 = data.player_data.spell1
		State.spell2 = data.player_data.spell2
		State.spell3= data.player_data.spell3
		State.helm = data.player_data.helm
		State.chest = data.player_data.chest
		State.gloves = data.player_data.gloves
		State.pants = data.player_data.pants
		State.boots = data.player_data.boots
		State.weapon = data.player_data.weapon
		State.health = data.player_data.health
		State.maxHealth = data.player_data.maxHealth
		State.cur_xp = data.player_data.cur_xp
		State.xp_to_next = data.player_data.xp_to_next
		State.armor = data.player_data.armor
		State.crit_chance = data.player_data.crit_chance
		State.rFire = data.player_data.rFire
		State.rFrost = data.player_data.rFrost
		State.rArcane = data.player_data.rArcane
		State.rBlood = data.player_data.rBlood
		State.rVoid = data.player_data.rVoid
		State.gold = data.player_data.gold
		State.inventory = data.player_data.player_inv
		State.quest_db = data.player_data.quest_db
		State.area_enemies = data.player_data.area_enemies
		State.Vendor_wares = data.player_data.Vendor_wares
		State.talents = data.player_data.player_talents
		loader.level_name = data.player_data.world
		get_tree().change_scene_to_file(str("res://scenes/levels/",loader.level_name,".tscn"))
		loader._ready()
		player.position.x = data.player_data.player_position_x
		player.position.y = data.player_data.player_position_y
		print(float(player.get_global_position().x)," ",float(player.get_global_position().y))
		player.camera_current()
		$"../".resume()
		
	else: 
		printerr("no file at %s!" % [path])
		return

