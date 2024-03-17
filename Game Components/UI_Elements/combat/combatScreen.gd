extends Node2D

@onready var enemy = $enemyCombat
@onready var player = $player
@onready var fight = $"combatUI/combat/cast"
@onready var exit_inv = $combatUI/return
@onready var inv = $combatUI/Inventory
@onready var inv_ui = $inventory_ui
@onready var eHealth = $combatUI/enemyHealth
@onready var pHealth = $combatUI/playerHealth
@onready var pHealth_label: Label = $combatUI/playerHealth/current_health
@onready var spell_book = $combatUI/spellSelect
@onready var yourTurn = 1
@onready var spells = State.spell_book
@onready var specialCounter = 0
@onready var enemyBook = State.enemies
@onready var eNameLabel = $combatUI/EnemyName
@onready var cam = $Camera2D
@onready var world_instance = get_tree().get_root().get_node('/root/root')
@onready var world_level = get_tree().get_root().get_node('/root/root').level_name
@onready var chosen_spell_desc: Label = $combatUI/combat/chosen_spell_desc
@onready var chosen_spell_dmg: Label = $combatUI/combat/chosen_spell_dmg
@onready var chosen_spell: Label = $combatUI/combat/chosen_spell_label
@onready var chosen_spell_text: String = chosen_spell.text
@onready var instruct: Label = $instruct
@onready var turn_sign: Label = $turn_sign
@onready var casts_left: int = State.casts:
	set(value):
		casts_left = value
		casts_left_label.text = str("Casts Left: ", casts_left)
		if casts_left < 1:
			State.can_use = false
		else:
			State.can_use = true
@onready var casts_left_label: Label = $cast_lefts
@onready var is_casting: bool
@onready var burning_for: int = 0:
	set(value):
		burning_for = value
		if value > 0:
			statusEffect.text = str("Burning x",burning_for)
			statusEffect.show()
		else:
			statusEffect.hide()
@onready var spellAnimation: AnimationPlayer = $spellEffects
@onready var spellTexture: AnimatedSprite2D = $"spell effect"
@onready var DoTEffect: AnimatedSprite2D = $"DoT effect"
@onready var statusEffect: Label = $combatUI/enemyHealth/status_effect
@onready var enemyAttack: AnimatedSprite2D = $"enemy attack"

#signals
signal combat_end
signal death


var rng = RandomNumberGenerator.new()




# Called when the node enters the scene tree for the first time.
func _ready():
	player.play("idle")
	pHealth.value = State.health
	spellTexture.hide()
	yourTurn = 1
	DoTEffect.hide()
	enemyAttack.hide()
	fight.grab_focus()
	pHealth_label.text = str("HP ",State.health,"/",State.maxHealth)
	#add_spells()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	chosen_spell.text = State.spell1
	chosen_spell_desc.text = State["spell_book"][State.spell1]["description"]
	chosen_spell_dmg.text = str("Damage: ",State["spell_book"][State.spell1]["damage"])
	

func start_turn():
	yourTurn = 1

func camera_current():
	cam.make_current()

	pass

#set up on combat start
func combat_data():
	enemy.enemyID(State.enemyID)
	enemy.world = world_level
	enemy.enemyType(State.engaging[0])
	eNameLabel.text = enemy.enemy_type
	enemy.enemyHealth()
	enemy.enemySprite.play(str(enemy.enemy_type,"_idle"))
	eHealth.value = enemy.health
	eHealth.max_value = enemy.max_health
	inv_ui.populate_grid()
	

# assign spells
func add_spells():
	pass


#handles all damage modification for casting combined spells
func castSpell() -> int:
	var damage: int
	var crit_chance = State.crit_chance
	var life_drain: float = 0.0
	var types = []
	var preResists = 0
	
	#check for attacks
	if spells[State.spell1]["class"]=="attack":
		damage += spells[State.spell1]["damage"]
		types.insert(0,str(spells[State.spell1]["type"]))

	
	# check for support spells
	if State.spell3 != '':
		if spells[State.spell3]["class"]=="support":
			var stats = spells[State.spell3]["stat_mod"].keys()
			match stats[0]:
				"crit_chance":
					crit_chance += spells[State.spell3]["stat_mod"]["crit_chance"]
				"life_drain":
					life_drain += spells[State.spell3]["stat_mod"]["life_drain"]
			
	
	# check for defense but only grab armor from one of them if multiple
	if State.spell1 !="":
		if spells[State.spell1]["class"]=="defend":
			State.armor += spells[State.spell1]["stat_mod"]["armor"]
	
	# check for blood type and do enemy self damage
	for type in types:
		if type == "blood":
			if specialCounter == 4:
				damage = enemyBook[enemy.enemy_type]["moves"]["special"]
				specialCounter = 0
			else:
				damage = enemyBook[enemy.enemy_type]["moves"]["basic"]
		elif type == "fire":
			burning_for = 3
	
	# final checks 
	#roll for crit
	var roll = rng.randf_range(0,100)
	if roll <= crit_chance:
		damage *= 2
		pass

	#handle spell resist
	if enemyBook[enemy.enemy_type]["resists"]:
		preResists = damage
		var resists = enemyBook[enemy.enemy_type]["resists"].keys()
		for resist in resists:
			match resist:
				"void":
					for type in types:
						if type == "void": 
							var reduce = (100 - enemyBook[enemy.enemy_type]["resists"]["void"]) * .01
							damage *= reduce

				"fire":
					for type in types:
						if type == "fire": 
							var reduce = (100 - enemyBook[enemy.enemy_type]["resists"]["fire"]) * .01
							damage *= reduce

				"frost":
					for type in types:
						if type == "frost": 
							var reduce = (100 - enemyBook[enemy.enemy_type]["resists"]["frost"]) * .01
							damage *= reduce

				"arcane":
					for type in types:
						if type == "arcane": 
							var reduce = (100 - enemyBook[enemy.enemy_type]["resists"]["frost"]) * .01
							damage *= reduce

				"blood":
					for type in types:
						if type == "blood": 
							var reduce = (100 - enemyBook[enemy.enemy_type]["resists"]["blood"]) * .01
							damage *= reduce
							

	#handle life_drain after all damage calcs are done
	if life_drain > 0.0:
		if State.health + (damage * life_drain) > State.maxHealth:
			State.health = State.maxHealth
		else:
			State.health += (damage * life_drain)
	if State.t_attack_up:
		print("base damage: ",damage)
		damage *= 1.20
		print("buffed damage: ",damage)
	return damage


####################### what happens during enemy turns #######################
func enemyTurn():
	if enemy.health >= 0:		
		showOptions()
		var damageTaken = 0
		await get_tree().create_timer(0.5).timeout

		# enemy attacks
		enemy.enemySprite.play(str(enemy.enemy_type,"_attack"))
		enemyAttack.play(enemy.enemy_type)
		enemyAttack.show()
		spellAnimation.play("enemy cast")
		await get_tree().create_timer(2).timeout
		if specialCounter < 5:
			damageTaken = (enemyBook[enemy.enemy_type]["moves"]["basic"] * rng.randf_range(1,1.1))
		else:
			damageTaken = (enemyBook[enemy.enemy_type]["moves"]["special"] * rng.randf_range(1,1.15))
		enemy.enemySprite.play(str(enemy.enemy_type,"_idle"))
		enemyAttack.hide()

		#handle player resist
		match enemyBook[enemy.enemy_type]["type"]:
			"void":
				var reduce = (100 - State.rVoid) * .01
				damageTaken *= reduce

			"void":
				var reduce = (100 - State.rFire) * .01
				damageTaken *= reduce

			"frost":
				var reduce = (100 - State.rFrost) * .01
				damageTaken *= reduce

			"arcane":
				var reduce = (100 - State.rArcane) * .01
				damageTaken *= reduce

			"blood":
				var reduce = (100 - State.rBlood) * .01
				damageTaken *= reduce

			"physical":
				var reduce = (100 - State.armor) * .01
				damageTaken *= reduce

		if specialCounter == 5:
			specialCounter = 0
		else:
			specialCounter += 1
		if State.t_shield:
			print("dmg reduced")
			State.health -= damageTaken * .85
		
		State.health -= damageTaken
		pHealth.value = State.health
		pHealth_label.text = str("HP ",State.health,"/",State.maxHealth)
		await get_tree().create_timer(2.0).timeout
		
		if burning_for > 0:
			burning_for -= 1
			DoTEffect.show()
			DoTEffect.play("burning")
			await get_tree().create_timer(2.0).timeout
			if State.t_kindling:
				enemy.updateHealth(10*1.20)
			else:
				enemy.updateHealth(10*1.20)
			eHealth.value = enemy.health
			DoTEffect.hide()
			
		
		
		
		yourTurn = 1
		turn_sign.text = "Your Turn"
		casts_left = State.casts
		if State.health < 1:
			death.emit()

	


# funcs to handle various UI elements and button presses
func showAttacks():
	# show the buttons we do need
	fight.show()
	spell_book.show()
	#defend.show()

	


	
func showOptions():
	# inv.show()
	# combat.show()
	# show the buttons we do need
	pass

# called when enemy or you dies
func endgame():
	var drops = State.enemies[enemy.enemy_type]["drops"].keys()
	print("getting drops")
	for drop in drops:
		State.update_inventory(drop,State.enemies[enemy.enemy_type]["drops"][drop])
		print(drop," added to inventory")
	State.cur_xp += round(pow(State.level,1.5)+State.level*2.6)
#	var killed = get_node(NodePath(str('../enemies/',enemy.enemy_type)))
#	killed.set_defeat(1)
	yourTurn = 1
	#get_tree().change_scene_to_file((str(State.prev_scene)))





func _on_combat_pressed():
	if yourTurn == 1:
		# hide buttons we don't need
		showAttacks()
	else:
		pass
	

func _on_inventory_pressed():
	if yourTurn == 1:
		inv.hide()
		inv_ui.show()
		exit_inv.show()
	
func _on_return_pressed():
	inv.show()
	# show the buttons we do need
	inv_ui.hide()
	exit_inv.hide()

func _on_onepunch_pressed():
	if yourTurn == 1 && State.spell1 != '' and is_casting == false:
		is_casting = true
		spellTexture.show()
		spellTexture.play(State.spell1)
		spellAnimation.play("spell cast")
		await get_tree().create_timer(1).timeout
		spellTexture.hide()
		is_casting = false
		instruct.hide()
		
		if casts_left > 0:
			enemy.updateHealth(castSpell())
			eHealth.value = enemy.health
			casts_left -= 1
			if casts_left == 0:
				yourTurn = 0
				turn_sign.text = "Enemy Turn"
				enemyTurn()
	


func _on_spell_pressed():
	pass # Replace with function body.



func _on_enemy_combat_dead():
	combat_end.emit()
	burning_for = 0




func _on_inventory_ui_item_used():
	casts_left -= 1
	enemyTurn() 
