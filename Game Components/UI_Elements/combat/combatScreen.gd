extends Node2D

@onready var enemy = $enemyCombat
@onready var player = $player
@onready var fight = $"combatUI/combat/cast"
@onready var exit_inv = $combatUI/return
@onready var inv = $combatUI/Inventory
@onready var inv_ui = $inventory_ui
@onready var eHealth = $combatUI/enemyHealth
@onready var eHealth_label : Label = $combatUI/enemyHealth_label
@onready var pHealth : TextureProgressBar = $combatUI/playerHealth
@onready var pHealth_label: Label = $combatUI/current_health
@onready var buff_label: Label = $combatUI/buffs
@onready var spell_book = $combatUI/spellSelect
@onready var yourTurn : bool = true
@onready var spells = State.spell_book
@onready var specialCounter = 0
@onready var enemyBook = State.enemies
@onready var eNameLabel = $combatUI/enemyInfo/HBoxContainer/EnemyName
@onready var cam = $Camera2D
@onready var quick_slots : QuickSlots = $"Quick Slots"
@onready var world_instance = get_tree().get_root().get_node('/root/root')
@onready var world_level = get_tree().get_root().get_node('/root/root').level_name
@onready var chosen_spell_desc: Label = $combatUI/combat/chosen_spell_desc
@onready var chosen_spell_dmg: Label = $combatUI/combat/chosen_spell_dmg
@onready var chosen_spell: Label = $combatUI/combat/chosen_spell_label
@onready var chosen_spell_text: String = chosen_spell.text
@onready var current_spell: String = State.spell1
#@onready var instruct: Label = $instruct
@onready var turn_sign: Label = $turn_sign
@onready var casts_left: int = State.casts:
	set(value):
		casts_left = value
		casts_left_label.text = str("Casts Left: ", casts_left)
		if casts_left < 1:
			State.can_use = false
			yourTurn = false
			turn_sign.text = "Enemy Turn"
			enemyTurn()
		else:
			State.can_use = true
@onready var casts_left_label: Label = $cast_lefts
@onready var is_casting: bool
@onready var burning_for: int = 0:
	set(value):
		burning_for = value
		if value > 0:
			burningText = str("Burning x",burning_for," ")
			statusEffect.text = burningText + poisonedText
		else:
			burningText = ""
			statusEffect.text = burningText + poisonedText
@onready var burningText: String
@onready var poisoned_for: int = 0:
	set(value):
			poisoned_for = value
			if value > 0:
				poisonedText = str("Poisoned x",poisoned_for," ")
				statusEffect.text = burningText + poisonedText
			else:
				poisonedText = ""
				statusEffect.text = burningText + poisonedText
@onready var poisonedText: String
@onready var spellAnimation: AnimationPlayer = $spellEffects
@onready var spellTexture: AnimatedSprite2D = $"spell effect"
@onready var DoTEffect: AnimatedSprite2D = $"DoT effect"
@onready var statusEffect: Label = $combatUI/enemyInfo/MarginContainer/status_effect
@onready var enemyAttack: AnimatedSprite2D = $"enemy attack"
@onready var bloodMoon: bool = false
@onready var fieldDuration: int = 0:
	set(value):
		fieldDuration = value
		if fieldDuration == 0:
			fieldEffect.hide()
			bloodMoon = false
@onready var fieldEffect: AnimatedSprite2D = $field
@onready var pet: AnimatedSprite2D = $Pet
@onready var defend: AnimatedSprite2D = $defend
@onready var shield_absorbed : int = 0
@onready var shielded: bool = false:
	set(value):
		shielded = value
		if shielded == false:
			defend.hide()
@onready var shield_for: int = 0:
	set(value):
		shield_for = value
		if shield_for < 1:
			shielded = false
			defend.hide()
			State.health += shield_absorbed
			pHealth.value = State.health
			pHealth_label.text = str("HP: ",State.health)
			shield_absorbed = 0
			buff_label.hide()
			buff_label.text = ''
		else:
			buff_label.show()
			buff_label.text = str("Shielded x",shield_for)
@onready var enemy_hit_chance: float = 1.0
@onready var hit_lowered_for: int = 0:
	set(value):
		hit_lowered_for = value
		if hit_lowered_for == 0:
			enemy_hit_chance = 1.0
@onready var confused: bool = false
@onready var confused_pity = 80 :
	set(value):
		if value <= 0:
			confused_pity = 0
		else :
			confused_pity = value
@onready var attack_reduced_by: float = 0.0
@onready var attack_reduced_for: int = 0
@onready var pet_spells = $"Pet/Pet Spells"
@onready var combat_event_1: Label = $Control/VBoxContainer/Label
@onready var combat_event_2: Label = $Control/VBoxContainer/Label2
@onready var combat_event_3: Label = $Control/VBoxContainer/Label3
@onready var combat_event_4: Label = $Control/VBoxContainer/Label4

@onready var enemy_info_enemy_type: Label = $Control/VBoxContainer2/HBoxContainer/VBoxContainer/enemyType
@onready var enemy_info_enemy_resist: Label = $Control/VBoxContainer2/HBoxContainer/VBoxContainer/enemyWeakness
@onready var enemy_info_next_attack: Label = $Control/VBoxContainer2/HBoxContainer/VBoxContainer/nextAttack
@onready var enemy_info_observations: Label = $Control/VBoxContainer2/observationContainer/observations
@onready var enemy_info_animation: AnimatedSprite2D = $Control/VBoxContainer2/HBoxContainer/Control/AnimatedSprite2D

@onready var spell1: spell_button = $combatUI/spellSelect/Control/VBoxContainer/row1/Spell1
@onready var spell2: spell_button = $combatUI/spellSelect/Control/VBoxContainer/row1/Spell2
@onready var spell3: spell_button = $combatUI/spellSelect/Control/VBoxContainer/row1/Spell3
@onready var spell4: spell_button = $combatUI/spellSelect/Control/VBoxContainer/row2/Spell4
@onready var spell5: spell_button = $combatUI/spellSelect/Control/VBoxContainer/row2/Spell5
@onready var spell6: spell_button = $combatUI/spellSelect/Control/VBoxContainer/row2/Spell6

@onready var sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var enemy_sounds: AudioStreamPlayer = $enemySounds
@onready var player_damage_sound: AudioStream = preload("res://sounds/UI/combat_1.wav")
@onready var confirm: AudioStream = preload("res://sounds/UI/pluck_REVERB_2.wav")
@onready var ghost_pain: AudioStream = preload("res://sounds/effects/enemy sounds/ghost_pain.wav")
@onready var techno_pain: AudioStream = preload("res://sounds/effects/enemy sounds/techno_pain.wav")
@onready var burning_sound: AudioStream = preload("res://sounds/effects/enemy sounds/fire-sound-effect-designed-fire-short-swoosh-120589.mp3")

@onready var tut1: Control = $"tutorials/Actions Per Turn"



#signals
signal combat_end
signal death


var rng = RandomNumberGenerator.new()





func _ready():
	if tut1:
		tut1.populate_tutorial()
	
	player.play("idle")
	buff_label.text = ''
	
	pHealth.value = State.health
	pHealth.max_value = State.maxHealth
	pHealth_label.text = str("HP ",State.health)
	
	yourTurn = true
	
	DoTEffect.hide()
	enemyAttack.hide()
	spellTexture.hide()
	
	statusEffect.text = burningText + poisonedText
	
	set_spells()
	State.current_spell = State.spell1
	chosen_spell_desc.visible_characters = -1


func _process(delta):	
	chosen_spell.text = State.current_spell
	chosen_spell_desc.text = State["spell_book"][State.current_spell]["description"]
	chosen_spell_dmg.text = str("Damage: ",State["spell_book"][State.current_spell]["damage"])
	if chosen_spell_desc.visible_characters > -1:
		chosen_spell_desc.visible_characters = -1
	

func set_spells() -> void:
	spell1.spell_icon = State.spell1
	spell2.spell_icon = State.spell2
	spell3.spell_icon = State.spell3
	spell4.spell_icon = State.spell4
	spell5.spell_icon = State.spell5
	spell6.spell_icon = State.spell6

func start_turn():
	statusEffect.text = burningText + poisonedText
	yourTurn = true

func camera_current():
	cam.make_current()

#set up on combat start
func combat_data():
	_ready()
	enemy.enemyID(State.enemyID)
	enemy.world = world_level
	enemy.enemyType(State.engaging[0])
	enemy.faction = State.enemies[State.engaging[0]]["faction"]
	eNameLabel.text = enemy.enemy_type
	enemy.enemyHealth()
	enemy.enemySprite.play(str(enemy.enemy_type,"_idle"))
	
	eHealth.max_value = enemy.max_health
	eHealth.value = enemy.health
	eHealth_label.text = str("HP: ",enemy.max_health)
	
	#inv_ui.populate_grid()
	quick_slots.setup()
	spell1.grab_focus()
	
	enemy_info_enemy_type.text = str("Enemy Type: ",enemy.enemy_type)
	enemy_info_enemy_resist.text = str("Enemy Weakness: ",enemyBook[enemy.enemy_type]["resists"])
	enemy_info_next_attack.text = str("Next Attack: ", )
	enemy_info_observations.text = str("Observations: ",enemyBook[enemy.enemy_type]["lore"])
	enemy_info_animation.play(str(enemy.enemy_type,"_idle"))
	


#handles all damage modification for casting combined spells
func castSpell() -> int:
	var damage: int
	var crit_chance = State.crit_chance
	var life_drain: float = 0.0
	var type: String = spells[State.current_spell]["type"]
	var preResists = 0
	
	#check for attacks
	if spells[State.current_spell]["class"]=="attack":
		damage += spells[State.current_spell]["damage"]
		combatTextUpdate(str("You cast ", State.spell1))
		
	# check for summon spells
	elif spells[State.current_spell]["class"] == "summon":
		pet.summoned = true
		pet.play(State.current_spell)
		combatTextUpdate(str("You summoned ",State.spell1))
		
	# check for defensive spells
	elif spells[State.current_spell]["class"]=="defend":
		match spells[State.current_spell]["name"]:
			"Sanguinated Shell":
				shielded = true
				shield_for = 3
				defend.play("Sanguinated Shell")
				defend.show()

	# check for field spells
	elif spells[State.current_spell]["class"]=="field":
		combatTextUpdate(str(State.current_spell, " transforms the battlefield"))
		match type:
			"blood": 
				bloodMoon = true
				fieldDuration = 3
				fieldEffect.show()


	# check for blood type and do enemy self damage
	match type:
		"Fire":
			burning_for = 3
			combatTextUpdate(str(enemy.enemy_type," is burning"))
		"Poison":
			poisoned_for = 3 
			combatTextUpdate(str(enemy.enemy_type," is poisoned"))
		"Void":
			if State.current_spell == "Hollowed Threats":
				attack_reduced_by = 0.2
				attack_reduced_for = 3
				combatTextUpdate(str(enemy.enemy_type,"'s strength reduced"))
			elif State.current_spell == "Void Sight":
				enemy_hit_chance -= 0.2
				hit_lowered_for = 3
				combatTextUpdate(str(enemy.enemy_type,"'s accuracy reduced"))
			elif State.current_spell == "Vapid Affliction":
				confused = true
				combatTextUpdate(str(enemy.enemy_type," may forget to attack"))

		
	# final checks 
	
	#roll for crit
	var roll = rng.randf_range(0,100)
	if roll <= crit_chance:
		damage *= 2
		

	##handle spell resist
	#if enemyBook[enemy.enemy_type]["resists"]:
		#
		#preResists = damage
		#
		#match enemyBook[enemy.enemy_type]["resists"]:
			#"void":
					#damage *= 0.5
			#"fire":
					#damage *= 0.5
			#"frost":
					#damage *= 0.5
			#"arcane": 
					#damage *= 0.5
			#"blood":
					#damage *= 0.5

	#handle life_drain after all damage calcs are done
	if life_drain > 0.0:
		if State.health + (damage * life_drain) > State.maxHealth:
			State.health = State.maxHealth
		else:
			State.health += (damage * life_drain)

	# handles attack up trait
	if State.t_attack_up:
		damage *= 1.20
	
	# handles the pet damage bonus
	if pet.summoned:
		damage *= 1.20
	
	statusEffect.text = burningText + poisonedText
	return damage


####################### what happens during enemy turns #######################
func enemyTurn():
	if enemy.health >= 0:		
		var damageTaken = 0
		await get_tree().create_timer(0.5).timeout

		# enemy attacks
		enemy.enemySprite.play(str(enemy.enemy_type,"_attack"))
		enemyAttack.play(enemy.enemy_type)
		enemyAttack.show()
		spellAnimation.play("enemy cast")
		await get_tree().create_timer(1).timeout # let the below trigger off animation played?
		sound.set_stream(player_damage_sound)
		sound.play()
		if specialCounter < 5:
			damageTaken = (enemyBook[enemy.enemy_type]["moves"]["basic"] * rng.randf_range(1,1.1))
		else:
			damageTaken = (enemyBook[enemy.enemy_type]["moves"]["special"] * rng.randf_range(1,1.15))
		enemy.enemySprite.play(str(enemy.enemy_type,"_idle"))
		enemyAttack.hide()

		##handle player resist
		#match enemyBook[enemy.enemy_type]["type"]:
			#"void":
				#var reduce = (100 - State.rVoid) * .01
				#damageTaken *= reduce
#
			#"fire":
				#var reduce = (100 - State.rFire) * .01
				#damageTaken *= reduce
#
			#"blood":
				#var reduce = (100 - State.rBlood) * .01
				#damageTaken *= reduce
#
			#"physical":
				#var reduce = (100 - State.armor) * .01
				#damageTaken *= reduce

		if specialCounter == 5: # TODO add set func to handle reset instead
			specialCounter = 0  #  if specialCounter is > 5 then = 0
		else:
			specialCounter += 1
		
		# handles damage reduction trait
		if State.t_shield:
			damageTaken *= 0.75

		# handles sanguine shell
		if shielded:
			shield_absorbed += (damageTaken/2)
			shield_for -= 1
			damageTaken *= 0.7

		
		# handles hollowed threats
		if attack_reduced_for > 0:
			damageTaken *= (1.0 - attack_reduced_by)
			attack_reduced_for -= 1
			
		# handles void sight
		if hit_lowered_for > 0 :
			if rng.randf_range(0.0,1.0) > enemy_hit_chance:
				hit_lowered_for -= 1
				yourTurn = true
				casts_left = State.casts
				return
		
		# handles vapid affliction effect 
		if confused:
			if rng.randf_range(1,100) < confused_pity:
				print("attacked through confusion")
				if (State.health - int(damageTaken)) < 0:
					State.health = 0
				else:
					State.health -= int(damageTaken)
				confused_pity -= 20
			else:
				print("Confused and didn't attack")
				confused = false
				confused_pity = 80
		else:
			if (State.health - int(damageTaken)) < 0:
				State.health = 0
			else:
				State.health -= int(damageTaken)

		pHealth.value = State.health
		combatTextUpdate(str(enemy.enemy_type," attacked for ",int(damageTaken)))
		pHealth_label.text = str("HP ",State.health)
		await get_tree().create_timer(1.0).timeout

		# handles burning damage
		if burning_for > 0:
			burning_for -= 1
			
			DoTEffect.show()
			enemy_sounds.set_stream(burning_sound)
			enemy_sounds.play()
			DoTEffect.play("burning")
			await get_tree().create_timer(2.0).timeout
			
			if State.t_kindling:
				enemy.updateHealth(10*1.20)
			else:
				enemy.updateHealth(10)
				
			eHealth.value = enemy.health
			eHealth_label.text = str("HP: ",enemy.health)
			
			DoTEffect.hide()
		
		# handles poison damage
		if poisoned_for > 0:
			poisoned_for -= 1
			
			DoTEffect.show()
			DoTEffect.play("poisoned")
			await get_tree().create_timer(2.0).timeout
			
			enemy.updateHealth(10)
			eHealth.value = enemy.health
			eHealth_label.text = str("HP: ",enemy.health)
			
			DoTEffect.hide()
			
		
		
		statusEffect.text = burningText + poisonedText
		if fieldDuration > 0:
			fieldDuration -= 1
		turn_sign.text = "Your Turn"
		casts_left = State.casts
		yourTurn = true
		if State.health < 1:
			death.emit()
			reset()



func combatTextUpdate(event: String) -> void:
	combat_event_4.text = combat_event_3.text
	combat_event_3.text = combat_event_2.text
	combat_event_2.text = combat_event_1.text
	combat_event_1.text = event
	
func clearCombatText() -> void:
	combat_event_4.text = ""
	combat_event_3.text = ""
	combat_event_2.text = ""
	combat_event_1.text = ""


# funcs to handle various UI elements and button presses
func showAttacks():
	# show the buttons we do need
	fight.show()
	spell_book.show()
	#defend.show()



# called when enemy or you dies
func endgame():
	
	var drops = State.enemies[enemy.enemy_type]["drops"].keys()
	print("getting drops")
	var drop_string: String
	for drop in drops:
		drop_string += str(drop," x",State.enemies[enemy.enemy_type]["drops"][drop],"\n")
		State.update_inventory(drop,State.enemies[enemy.enemy_type]["drops"][drop])
		print(drop," added to inventory")
	State.populate_last_enemy_defeated(
		enemy.enemy_type
		,drop_string
		,str(round(pow(State.level,1.5)+State.level*2.6))
	)
	State.cur_xp += round(pow(State.level,1.5)+State.level*2.6)
	yourTurn = true


func enemy_damage_sound_player() -> void :
	match enemy.enemy_type:
		"ghost" : 
			enemy_sounds.set_stream(ghost_pain)
			enemy_sounds.volume_db = -15
			enemy_sounds.play()
		"Technotheist Grunt" : 
			enemy_sounds.set_stream(techno_pain)
			enemy_sounds.volume_db = 0
			enemy_sounds.play()
		"Void Squirrel" :
			enemy_sounds.set_stream(ghost_pain)
			enemy_sounds.volume_db = -15
			enemy_sounds.play()
		"executioner" : 
			enemy_sounds.set_stream(ghost_pain)
			enemy_sounds.volume_db = -15
			enemy_sounds.play()
		"Sorrow Shade" : 
			enemy_sounds.set_stream(ghost_pain)
			enemy_sounds.volume_db = -15
			enemy_sounds.play()



func reset():
	burning_for = 0
	poisoned_for = 0
	shielded = false
	shield_for = 0
	pet.summoned = false
	hit_lowered_for = 0
	clearCombatText()
	fieldDuration = 0


func item_use(item) -> void :
	if State.check_inv(item) > 0:
		match item :
			"health restore" :
				if State.health < State.maxHealth:
					if State.health + 45 > State.maxHealth:
						State.health = State.maxHealth
					else:
						State.health += 45
					pHealth.value = State.health
					pHealth_label.text = str("HP: ",State.health)
					State.inventory[item] -= 1
					if State.check_inv(item) <= 0:
						quick_slots.setup()
					casts_left -= 1
					combatTextUpdate("You healed for 45 HP")
			"Coffin Nails" :
				if enemy.faction == "Spirit" :
					enemy.updateHealth(55)
					eHealth.value = enemy.health
					eHealth_label.text = str("HP: ",enemy.health)
					casts_left -= 1
					State.inventory[item] -= 1
					combatTextUpdate(str("Coffin Nails damaged ",enemy.enemy_type," for 55"))
			"Void Nut" :
				if enemy.enemy_type == "Void Squirrel" :
					enemy.updateHealth(55)
					eHealth.value = enemy.health
					eHealth_label.text = str("HP: ",enemy.health)
					casts_left -= 1
					State.inventory[item] -= 1
					combatTextUpdate(str("The Void Squirrel chased after the nut!"))
			"RIP'd CD" :
				if enemy.faction == "Technotheist" :
					enemy.updateHealth(45)
					eHealth.value = enemy.health
					eHealth_label.text = str("HP: ",enemy.health)
					casts_left -= 1
					State.inventory[item] -= 1
					combatTextUpdate(str("RIP'd CD damaged ",enemy.enemy_type," for 45"))

		quick_slots.setup()
				
				
func _on_inventory_pressed():
	if yourTurn == true:
		inv.hide()
		inv_ui.show()
		exit_inv.show()
	
func _on_return_pressed():
	inv.show()
	# show the buttons we do need
	inv_ui.hide()
	exit_inv.hide()

func _on_onepunch_pressed():
	
	if casts_left > 0 :
		if yourTurn && State.current_spell != '' && is_casting == false:
			sound.set_stream(confirm)
			sound.play()
			Input.start_joy_vibration(0,0.9,0.5,0.1)
			is_casting = true
			if spells[State.current_spell]["class"]  == "attack" and pet.summoned == true:
				spellTexture.show()
				pet_spells.show()
				pet_spells.play(State.current_spell)
				spellTexture.play(State.current_spell)
				spellAnimation.play("spell cast")
				await get_tree().create_timer(1).timeout
				enemy_damage_sound_player() 
				spellTexture.hide()
				pet_spells.hide()
			elif spells[State.current_spell]["class"]  == "attack":
				spellTexture.show()
				spellTexture.play(State.current_spell)
				spellAnimation.play("spell cast")
				await get_tree().create_timer(1).timeout		
				enemy_damage_sound_player() 
				spellTexture.hide()
			is_casting = false
			#instruct.hide()
			if casts_left > 0:
				enemy.updateHealth(castSpell())
				eHealth.value = enemy.health
				eHealth_label.text = str("HP: ",enemy.health)
				casts_left -= 1

func _on_enemy_combat_dead():
	combat_end.emit()
	SteamFeatures.setAchievement("ACH_Kill")
	reset()
	

func _on_inventory_ui_item_used():
	casts_left -= 1


func _on_quick_slots_slot_1_used():
	if yourTurn:
		item_use(State.quick_slot_1)


func _on_quick_slots_slot_2_used():
	if yourTurn:
		item_use(State.quick_slot_2)


func _on_quick_slots_slot_3_used():
	if yourTurn:
		item_use(State.quick_slot_3)


func _on_quick_slots_slot_4_used():
	if yourTurn:
		item_use(State.quick_slot_4)
