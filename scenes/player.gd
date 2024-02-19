extends CharacterBody2D

@onready var inv = $HUD/character_info/Inventory
@onready var q_log = $HUD/character_info/quest_log
@onready var itemLabel = $interactionComponents/interactionArea/itemLabel
@onready var goldLabel = $HUD/character_info/gold
@onready var character_screen = $HUD/character_info
@onready var cur_level = $"HUD/character_info/current level"
@onready var xp_label = $HUD/character_info/cHUB/XP
@onready var hp_label = $HUD/character_info/cHUB/Health
@onready var shop = $HUD/shop
@onready var pause = $HUD/PauseController
@onready var rain = $Weather
@onready var talents = $HUD/TalentTree
@onready var qBook = State.quest_db.keys()
@onready var all_interactions = []



var speed = 150.0


var current_dir = "none"
var world = ''

signal combat_entered

func _ready():
	$AnimatedSprite2D.play("idle")
	update_HUD()
	State.level_up()
	character_screen.visible = false
	


func _physics_process(delta):
	if State.is_raining == 0:
		rain.hide()
	else:
		rain.emitting = State.is_raining
		
	player_movement(delta)
	update_HUD()
	
	if character_screen.visible == true:
		inv.populate_grid()
		q_log.populate_log()
	
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	if Input.is_action_just_pressed("action"):
		pass
	if Input.is_action_just_pressed("character_screen"):
		if character_screen.visible == true:
			character_screen.visible = false
		else:
			character_screen.visible = true
			update_HUD()
#			inv.populate_grid()
#			q_log.populate_log()
	if Input.is_action_just_pressed("Talents"):
		if talents.visible == true:
			talents.visible = false
		else:
			talents.visible = true
		pass

func player_movement(_delta):
	
	if Input.is_action_pressed("MOVE_RIGHT"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("MOVE_LEFT"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("MOVE_DOWN"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("MOVE_UP"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
	

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("up_walk")
		elif movement == 0:
			anim.play("up_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("down_walk")
		elif movement == 0:
			anim.play("idle")
			
######################UI Element Data#################################
func update_HUD():
	xp_label.text = str("XP: ",State.cur_xp,"/",State.xp_to_next," (",((float(State.cur_xp)/State.xp_to_next)*100),"%)")
	hp_label.text = str("HP: ",State.health,"/",State.maxHealth)
	goldLabel.text = str(State.gold," g")
	inv.populate_grid()
	q_log.populate_log()
		
	if cur_level.text == "":
		cur_level.text = str("LVL: ",State.level)
	elif (int(cur_level.text) != State.level) and State.level == 1:
		cur_level.text = str("Lvl: ",State.level)
	elif (int(cur_level.text) != State.level) and State.level > 1:
		cur_level.text = str("Lvl: ",State.level)
		itemLabel.text = str("Lvl ",State.level,"reached!")
		await get_tree().create_timer(3).timeout
		itemLabel.text = ""
	

		
		


func get_world():
	return world

############################interactions########################################
func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"vendor":
				shop.show()
				pass
			"quest_giver":
				if State.talking == 0:
					cur_interaction.set_value("yes")
					cur_interaction.talk(str("res://Game Components/dialogue/NPC/",
							cur_interaction.get_parent().sprite,".dialogue"))
					cur_interaction.get_parent().hasTalked(0)
					cur_interaction.get_parent().get_NPC_state()
					State.talking = 1
				else:
					pass
			#secret passage
			"secret":
				cur_interaction.set_value("0.0")
				print("secret opened")
			
			#door logic
			"gateway":
				if cur_interaction.interact_value == "in":
					print(get_parent().level_name)
					State.p_locs[get_parent().level_name] = get_node("../player").global_position
					get_tree().change_scene_to_file((str("res://scenes/levels/",
							cur_interaction.interact_label)))
				elif cur_interaction.interact_value == "out":
					get_tree().change_scene_to_file((str("res://scenes/levels/",
															cur_interaction.interact_label)))
			
			#locked door
			"locked_door":
				if State.inventory.keys().has("Gate Key"):
					if cur_interaction.interact_value == "in":
						print(get_parent().level_name)
						State.p_locs[get_parent().level_name] = get_node("../player").global_position
						get_tree().change_scene_to_file((str("res://scenes/levels/",
								cur_interaction.interact_label)))
					elif cur_interaction.interact_value == "out":
						get_tree().change_scene_to_file((str("res://scenes/levels/",
								cur_interaction.interact_label)))
				else:
					itemLabel.text = "The Gate's Locked..."	
					await get_tree().create_timer(2).timeout
					itemLabel.text = ""
			
			#signs
			"sign":
				itemLabel.text = cur_interaction.interact_label
				await get_tree().create_timer(2).timeout
				itemLabel.text = ""
			
			"lootable":
				#handles looting
				# displays what we just looted
				itemLabel.text = str("Picked up ",all_interactions[0].interact_value," ",
										all_interactions[0].interact_label)
				if State.inventory.has(cur_interaction.interact_label):
						State.inventory[cur_interaction.interact_label] += int(cur_interaction.interact_value) 
						cur_interaction.interact_value = str(int(cur_interaction.interact_value)-1)
						if (int(cur_interaction.interact_value) == 0):
							cur_interaction.get_parent().visible = false
							cur_interaction.monitorable = false
						print(State.inventory)
				else:
					inv.populate_grid()
					itemLabel.text = str("Picked up ",all_interactions[0].interact_value," ",
							all_interactions[0].interact_label)
					State.inventory[cur_interaction.interact_label] = int(cur_interaction.interact_value)
					cur_interaction.interact_value = str(int(cur_interaction.interact_value)-1)
					if (int(cur_interaction.interact_value) == 0):
							cur_interaction.get_parent().visible = false
							cur_interaction.monitorable = false
					print(State.inventory)
				await get_tree().create_timer(2).timeout
				itemLabel.text = ""


func camera_current():
	$HUD/Camera2D.make_current()
	pass

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0,area)
	

	#sets up the combat vars and launching combatScene
	var cur_interact = all_interactions[0]
	if cur_interact.interact_type == "enemy" and State.combat == 0:
		State.p_locs[get_parent().level_name] = get_node("../player").global_position
		State.engaging.insert(0,cur_interact.interact_label)	
		State.enemyID = cur_interact.get_parent().id
		State.prev_scene = NodePath(get_tree().current_scene.scene_file_path)
		State.engaging.insert(0,cur_interact.interact_label)
		State.talking = 1
		combat_entered.emit()
		State.combat = 1


	else:
		pass
		
	
	
	



func _on_interaction_area_area_exited(area):
	var cur_interact = all_interactions[0]
	#if cur_interact.interact_type == "enemy":
		#State.combat = 0
	cur_interact.talk_end()
	shop.hide()
	State.talking = 0
	all_interactions.erase(area)
	

func _on_buy_button_pressed():
	$HUD/shop/ColorRect/buy/BuyButton/BuyIndicate.show()
	$HUD/shop/ColorRect/sell/SellButton/SellIndicate.hide()
	pass # Replace with function body.


func _on_sell_button_pressed():
	$HUD/shop/ColorRect/sell/SellButton/SellIndicate.show()
	$HUD/shop/ColorRect/buy/BuyButton/BuyIndicate.hide()
	pass # Replace with function body.


func _on_item_pressed():
	if int($HUD/shop/Sprite2D/buy/item/costLabel.text) < State.gold:
		#inv.add_item(str($HUD/shop/ColorRect/buy/item/itemlabel.text))
		State.update_inventory(str($HUD/shop/Sprite2D/buy/item/itemlabel.text),1)
		State.gold -= int($HUD/shop/Sprite2D/buy/item/costLabel.text)
	else:
		# add message about being too poor 
		pass

