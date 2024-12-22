extends CharacterBody2D

@onready var inv = $HUD/character_info/Inventory
@onready var q_log = $HUD/character_info/quest_log
@onready var itemLabel: Label = $interactionComponents/interactionArea/itemLabel
@onready var goldLabel : Label= $HUD/character_info/gold
@onready var character_screen = $HUD/character_info
@onready var cur_level = $"HUD/character_info/current level"
@onready var xp_label: Label = $HUD/character_info/cHUB/XP
@onready var hp_label: Label = $HUD/character_info/cHUB/Health
@onready var shop = $HUD/shop
@onready var pause = $Control/PauseController
@onready var rain: GPUParticles2D = $Weather
@onready var talents = $HUD/TalentTree
@onready var qBook = State.quest_db.keys()
@onready var all_interactions = []
@onready var prompt: Sprite2D = $prompt
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var moving : bool = false
@onready var facing : String
@onready var settings: Settings = $HUD/Settings
@onready var pad_prompt: Resource = load("res://Game Components/UI_Elements/prompts/tile_0308.png")
@onready var mkb_prompt: Resource = load("res://Game Components/UI_Elements/prompts/f.png")
@onready var mkb_quick_slots_binding_label: Control = $"HUD/character_info/Quick Slots/keyboard_slot_labels"
@onready var sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var open_book: AudioStream = preload("res://sounds/UI/book_open_1.wav")
@onready var close_book: AudioStream = preload("res://sounds/UI/book_close_1.wav")
@onready var journal_tutorial: Control = $HUD/tutorials/journal_1

var speed = 110.0
var current_dir = "none"
var world = ''

signal combat_entered

func _ready():
	$AnimatedSprite2D.play("idle")
	update_HUD()
	State.level_up()
	character_screen.visible = false
	talents.hide()
	settings.hide()
	itemLabel.text = ""
	prompt.hide()
	pause.hide()
	shop.hide()

func _unhandled_input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		prompt.texture = pad_prompt
		State.control_schema = "gamepad"
		mkb_quick_slots_binding_label.hide()
		
	elif event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		prompt.texture = mkb_prompt
		State.control_schema = "mkb"
		mkb_quick_slots_binding_label.show()
		
		
		
func _physics_process(delta):
	if State.is_raining == 0:
		rain.hide()
	else:
		rain.emitting = State.is_raining
		
				
	player_movement(delta)
	update_HUD()
		
	
	
	##### controls ####
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	if !State.combat:
		if Input.is_action_just_pressed("pause"):
			if settings.visible == true:
				animation.play("hud_down")
				sound.set_stream(close_book)
				sound.play()
				await get_tree().create_timer(0.5).timeout
				settings.hide()
				State.can_walk = true
			else:
				State.can_walk = false
				talents.hide()
				character_screen.hide()
				settings.set_focus()
				settings.show()
				animation.play("hud_up")
				sound.set_stream(open_book)
				sound.play()
				await get_tree().create_timer(0.5).timeout	

		if Input.is_action_just_pressed("character_screen"):
			if character_screen.visible == true:
				animation.play("hud_down")
				sound.set_stream(close_book)
				sound.play()
				await get_tree().create_timer(0.5).timeout
				character_screen.visible = false
				State.can_walk = true
			else:
				State.can_walk = false
				talents.hide()
				settings.hide()
				character_screen.visible = true
				update_HUD()
				$HUD/character_info/Inventory.update_input_prompt()
				if State.control_schema == 'gamepad':
					$HUD/character_info/Inventory.set_focus()
				animation.play("hud_up")
				sound.set_stream(open_book)
				sound.play()
				await get_tree().create_timer(0.5).timeout
				if State.tutorials["journal_1"]["seen"] == 0:
					journal_tutorial.populate_tutorial()
		
		if Input.is_action_just_pressed("Talents"):
			if talents.visible == true:
				animation.play("hud_down")
				sound.set_stream(close_book)
				sound.play()
				await get_tree().create_timer(0.5).timeout
				talents.visible = false
				State.can_walk = true
			else:
				State.can_walk = false
				animation.play("hud_up")
				sound.set_stream(open_book)
				sound.play()
				
				character_screen.hide()
				settings.hide()
				talents.set_focus()
				talents.show()


func player_movement(_delta):
# setup direction of movement
	if State.can_walk and !State.shopping:
		var direction = Input.get_vector("MOVE_LEFT", "MOVE_RIGHT", "MOVE_UP", "MOVE_DOWN")
		
		
		direction = direction.normalized()	
		velocity = direction * speed

		if velocity == Vector2.ZERO: moving = false
		else : moving = true

		play_anim(direction)	
		move_and_slide()
		

func play_anim( speed : Vector2 ):
	var anim = $AnimatedSprite2D
	
	if speed.y > 0 && abs(speed.x) < 0.6 :
		facing = "down"
	elif speed.y < 0 && abs(speed.x) < 0.6 :
		facing = "up"

	if speed.x > 0 and abs(speed.y) < 0.6:
		facing = "right"
	elif speed.x < 0 and abs(speed.y) < 0.6:
		facing = "left"
	elif speed.x == 0:
		pass


	
	if facing == "right":
		anim.flip_h = false
		if moving:
			anim.play("side_walk")
		elif !moving:
			anim.play("side_idle")
	elif facing == "left":
		anim.flip_h = true
		if moving:
			anim.play("side_walk")
		elif !moving:
			anim.play("side_idle")
	elif facing == "up":
		if moving:
			anim.play("up_walk")
		elif !moving:
			anim.play("up_idle")
	elif facing == "down":
		if moving:
			anim.play("down_walk")
		if !moving:
			anim.play("idle")

		
######################UI Element Data#################################
func update_HUD():
	xp_label.text = str("XP: ",State.cur_xp,"/",State.xp_to_next," (",int((float(State.cur_xp)/State.xp_to_next)*100),"%)")
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
		itemLabel.text = str("Level ",State.level,"!")
		await get_tree().create_timer(5).timeout
		itemLabel.text = ""
	

		
func shop_handler() -> void:
		settings.hide()
		talents.hide()
		character_screen.hide()
		shop.show()
		animation.play("hud_up")
		shop.doorbell()
		shop.set_focus()



func get_world():
	return world

############################interactions########################################
func execute_interaction():
	if all_interactions:
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"vendor":
				if State.talking == 0:
					State.talking = 1
					State.shopping = true
					cur_interaction.talk(str("res://Game Components/dialogue/NPC/",
					cur_interaction.get_parent().sprite,".dialogue"))
			"dialogue":
				if State.talking == 0:
					State.talking = 1
					prompt.hide()
					cur_interaction.talk(str("res://Game Components/dialogue/NPC/",
								cur_interaction.interact_label,".dialogue"))
			"quest_giver":
				if State.talking == 0:
					State.talking = 1
					prompt.hide()
					cur_interaction.set_value("yes")
					cur_interaction.talk(str("res://Game Components/dialogue/NPC/",
							cur_interaction.get_parent().sprite,".dialogue"))
					cur_interaction.get_parent().hasTalked(0)
					cur_interaction.get_parent().get_NPC_state()
				else:
					pass
			#secret passage
			"secret":
				if cur_interaction.interact_value == "0":
					cur_interaction.set_value("1")
			
			#door logic
			"gateway":
				#if cur_interaction.interact_value == "in":
				State.p_locs[get_parent().level_name] = global_position
				SceneTransition.change_scene(cur_interaction.interact_label)
				#elif cur_interaction.interact_value == "out":
					#SceneTransition.change_scene((str("res://scenes/levels/",
															#cur_interaction.interact_label)))
				if State.p_locs.has(get_parent().level_name):
						global_position = Vector2(State.p_locs[get_parent().level_name])
			
			#locked door
			"locked_door":
				if State.inventory.keys().has("Gate Key"):
					if cur_interaction.interact_value == "in":
						print(get_parent().level_name)
						State.p_locs[get_parent().level_name] = get_node("../player").global_position
						SceneTransition.change_scene(cur_interaction.interact_label)
					elif cur_interaction.interact_value == "out":
						SceneTransition.change_scene(cur_interaction.interact_label)
				else:
					itemLabel.text = "The Gate's Locked..."	
					await get_tree().create_timer(5).timeout
					itemLabel.text = ""
			
			#signs
			"sign":
				itemLabel.text = cur_interaction.interact_label
				await get_tree().create_timer(5).timeout
				itemLabel.text = ""
			
			"lootable":
				#handles looting
				# displays what we just looted
				itemLabel.text = str("Picked up ",all_interactions[0].interact_value," ",
										all_interactions[0].interact_label)
				if State.inventory.has(cur_interaction.interact_label):
						State.inventory[cur_interaction.interact_label] += int(cur_interaction.interact_value) 
						
						cur_interaction.get_parent().visible = false
						cur_interaction.monitorable = false
						
						print(State.inventory)
				else:
					inv.populate_grid()
					itemLabel.text = str("Picked up ",all_interactions[0].interact_value," ",
							all_interactions[0].interact_label)
					State.inventory[cur_interaction.interact_label] = int(cur_interaction.interact_value)
					cur_interaction.interact_value = 0

					cur_interaction.get_parent().visible = false
					cur_interaction.monitorable = false
					
					print(State.inventory)
				await get_tree().create_timer(5).timeout
				itemLabel.text = ""
			
			"portal":
				# portals are used instead of gateways when the player is moving
				# to a new location within the same scene, so a gateway isn't needed
				var portal_name = cur_interaction.interact_value
				var portal = get_node(str("../portals/",portal_name))
				SceneTransition.fade_out()
				global_position = portal.global_position
				SceneTransition.fade_in()


func camera_current():
	$Camera2D.make_current()



func _on_interaction_area_area_entered(area):
	all_interactions.insert(0,area)
	var cur_interact = all_interactions[0]
	
	if cur_interact.interact_type == "ach":
		SteamFeatures.setAchievement(cur_interact.interact_label)
	
	if cur_interact.interact_type == "heal":
		if State.health < State.maxHealth:
			State.health = State.maxHealth
			itemLabel.text = "Fully Healed!!"
			await get_tree().create_timer(.5).timeout
			itemLabel.text = ""
	
	if (cur_interact.interact_type != "secret" and cur_interact.interact_type != "ach" and cur_interact.interact_type != "heal") and !State.hide_control_hints:
		prompt.show()
	else:
		prompt.hide()
	
	#sets up the combat vars and launching combatScene
	if cur_interact.interact_type == "enemy" and !State.combat:
		State.p_locs[get_parent().level_name] = get_node("../player").global_position
		State.engaging.insert(0,cur_interact.interact_label)	
		State.enemyID = cur_interact.get_parent().id
		State.prev_scene = NodePath(get_tree().current_scene.scene_file_path)
		State.engaging.insert(0,cur_interact.interact_label)
		State.talking = 1
		combat_entered.emit()
		State.combat = true
	

func _on_interaction_area_area_exited(area):
	var cur_interact = all_interactions[0]
	cur_interact.talk_end()
	#if cur_interact.interact_type == "vendor" and shop.visible:
		#animation.play("hud_down")
	prompt.hide()
	State.talking = 0
	all_interactions.erase(area)
	await get_tree().create_timer(.5).timeout
	shop.hide()
	

func _on_item_pressed():
	if int($HUD/shop/Sprite2D/buy/item/costLabel.text) < State.gold:
		#inv.add_item(str($HUD/shop/ColorRect/buy/item/itemlabel.text))
		State.update_inventory(str($HUD/shop/Sprite2D/buy/item/itemlabel.text),1)
		State.gold -= int($HUD/shop/Sprite2D/buy/item/costLabel.text)
	else:
		# play poor sound 
		pass


func _on_shop_exit():
	if shop.visible:
		animation.play("hud_down")
		State.shopping = false
