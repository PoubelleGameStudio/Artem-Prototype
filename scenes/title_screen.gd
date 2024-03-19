extends Node2D
class_name title_screen

@export var level_name: String = ''
const SAVE_DIR = "user://saves/"
var save_file = "PlayerSave.tres"
var playerData = PlayerData.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneTransition.fade_in()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_game_pressed():
	SceneTransition.fade_out()
	get_tree().change_scene_to_file("res://scenes/levels/grimsBriar.tscn")
	
func _on_new_game_focus_entered():
	toggle_focus_mark($"CanvasLayer/HBoxContainer2/New Game/ColorRect")


func _on_new_game_focus_exited():
	toggle_focus_mark($"CanvasLayer/HBoxContainer2/New Game/ColorRect")


func _on_new_game_mouse_entered():
	toggle_focus_mark($"CanvasLayer/HBoxContainer2/New Game/ColorRect")


func _on_new_game_mouse_exited():
	toggle_focus_mark($"CanvasLayer/HBoxContainer2/New Game/ColorRect")
	$"CanvasLayer/HBoxContainer2/New Game".release_focus()


func _on_load_pressed():
	SceneTransition.fade_out()
	playerData = ResourceLoader.load(SAVE_DIR + save_file).duplicate(true)
	load_player()


func _on_exit_pressed():
	get_tree().quit()


func _on_exit_focus_entered():
	toggle_focus_mark($CanvasLayer/HBoxContainer2/Exit/ColorRect4)


func _on_exit_focus_exited():
	toggle_focus_mark($CanvasLayer/HBoxContainer2/Exit/ColorRect4)


func _on_exit_mouse_entered():
	toggle_focus_mark($CanvasLayer/HBoxContainer2/Exit/ColorRect4)


func _on_exit_mouse_exited():
	toggle_focus_mark($CanvasLayer/HBoxContainer2/Exit/ColorRect4)


func _on_load_focus_entered():
	toggle_focus_mark($CanvasLayer/HBoxContainer2/Load/ColorRect2)


func _on_load_focus_exited():
	toggle_focus_mark($CanvasLayer/HBoxContainer2/Load/ColorRect2)


func _on_load_mouse_entered():
	toggle_focus_mark($CanvasLayer/HBoxContainer2/Load/ColorRect2)


func _on_load_mouse_exited():
	toggle_focus_mark($CanvasLayer/HBoxContainer2/Load/ColorRect2)






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
	State.inventory = playerData.player_inv
	State.quest_db = playerData.quest_db 
	State.area_enemies = playerData.area_enemies
	State.Vendor_wares = playerData.Vendor_wares

	State.tutorials = playerData.tutorials
	get_tree().change_scene_to_file((str("res://scenes/levels/",playerData.world,".tscn")))


func toggle_focus_mark(node) -> void:
	if node.visible:
		node.hide()
		print("node hid")
	else:
		node.show()


# Replace with function body.
