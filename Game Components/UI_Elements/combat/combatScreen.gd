extends Node2D

@onready var enemy = $enemyCombat
@onready var player = $player
@onready var flee = $combatUI/Flee
@onready var combat = $combatUI/combat/Combat
@onready var fight = $"combatUI/combat/cast"
@onready var defend = $"combatUI/combat/guard"
@onready var exit_inv = $combatUI/return
@onready var inv = $combatUI/Inventory
@onready var inv_ui = $inventory_ui
@onready var eHealth = $combatUI/enemyHealth
@onready var pHealth = $combatUI/playerHealth
@onready var spell1 = $combatUI/spellSelect/spell1
@onready var spell2 = $combatUI/spellSelect/spell2
@onready var spell3 = $combatUI/spellSelect/spell3
@onready var yourTurn = 1
@onready var spells = State.spell_book
@onready var specialCounter = 0
@onready var enemyBook = State.enemies
@onready var eNameLabel = $combatUI/EnemyName
@onready var cam = $Camera2D
@onready var world_level = get_tree().get_root().get_node('/root/root').level_name

#signals
signal combat_end
signal death

var rng = RandomNumberGenerator.new()

# over time effect trackers
var burnTime = 0 	# turns enemy is burning
var burnDamage = 0 	# amount enemy burns for
var frozen = 0 		# is enemy frozen




# Called when the node enters the scene tree for the first time.
func _ready():
	player.play("idle")
	add_spells()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	eHealth.value = enemy.health
	pHealth.value = State.health
	if enemy.health <= 0:
		combat_end.emit()
		


func camera_current():
	cam.make_current()
	pass

#set up on combat start
func combat_data():
	enemy.world = world_level
	enemy.enemyType(State.engaging[0])
	eNameLabel.text = enemy.enemy_type
	enemy.enemySprite.play(str(enemy.enemy_type,"_idle"))
	eHealth.value = enemy.health
	inv_ui.populate_grid()
	

# assign spells
func add_spells():
	var options = spells.keys()
	spell1.add_item(State.spell1) 
	spell2.add_item(State.spell2)
	spell3.add_item(State.spell3)
	for opt in options:
		print(opt)
		if opt != State.spell1:
			spell1.add_item(str(opt))
		if opt != State.spell2:	 
			spell2.add_item(str(opt))
		if opt != State.spell3:
			spell3.add_item(str(opt))


#handles all damage modification for casting combined spells
func castSpell() -> int:
	var damage: int
	var attackCount: int = 0
	var crit_chance = State.crit_chance
	var life_drain: float = 0.0
	var types = []
	var preResists = 0
	
	#check for attacks
	if spells[State.spell1]["class"]=="attack":
		damage += spells[State.spell1]["damage"]
		types.insert(0,str(spells[State.spell1]["type"]))
		attackCount += 1
	if State.spell2 != '':
		if spells[State.spell2]["class"]=="attack":
			damage += spells[State.spell2]["damage"]
			types.insert(0,str(spells[State.spell2]["type"]))
			attackCount += 1
	if State.spell3 != '':
		if spells[State.spell3]["class"]=="attack":
			damage += spells[State.spell3]["damage"]
			types.insert(0,str(spells[State.spell3]["type"]))
			attackCount += 1
	# damage /= attackCount
		
	# check for empowerments
	if attackCount > 1:
		if spells[State.spell1]["name"] == spells[State.spell2]["name"]  and spells[State.spell2]["name"] == spells[State.spell3]["name"]:
			damage *= 1.5
		elif spells[State.spell1] == spells[State.spell2]:
			damage *= 1.25
		elif spells[State.spell2] == spells[State.spell3]:
			damage *= 1.25
		elif spells[State.spell1] == spells[State.spell3]:
			damage *= 1.25
		print("empowered spell: ",damage)
	
	# check for support spells
	if State.spell3 != '':
		if spells[State.spell3]["class"]=="support":
			print("found support spell")
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
	if State.spell2 != "":
		if spells[State.spell2]["class"]=="defend":
			State.armor += spells[State.spell2]["stat_mod"]["armor"]
	if State.spell3 !="":
		if spells[State.spell3]["class"]=="defend":
			State.armor += spells[State.spell3]["stat_mod"]["armor"]
	
	# check for blood type and do enemy self damage
	for type in types:
		if type == "blood":
			print("found blood")
			if specialCounter == 4:
				damage = enemyBook[enemy.enemy_type]["moves"]["special"]
				specialCounter = 0
			else:
				damage = enemyBook[enemy.enemy_type]["moves"]["basic"]
	
	# final checks 
	#roll for crit
	var roll = rng.randf_range(0,100)
	if roll <= crit_chance:
		damage *= 2
		print("spell crit for ",damage)
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
	
	print("total damage :",damage)
	return damage


####################### what happens during enemy turns #######################
func enemyTurn():
	showOptions()
	var damageTaken = 0
	await get_tree().create_timer(0.5).timeout

	# enemy attacks
	enemy.enemySprite.play(str(enemy.enemy_type,"_attack"))
	await get_tree().create_timer(2).timeout
	if specialCounter < 5:
		damageTaken = (enemyBook[enemy.enemy_type]["moves"]["basic"] * rng.randf_range(1,1.1))
		print("basic attack")
	else:
		damageTaken = (enemyBook[enemy.enemy_type]["moves"]["special"] * rng.randf_range(1,1.15))
		print("special attack")
	enemy.enemySprite.play(str(enemy.enemy_type,"_idle"))

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
	State.health -= damageTaken
	yourTurn = 1
	print("player health: ",State.health)
	


# funcs to handle various UI elements and button presses
func showAttacks():
	flee.hide()
	inv.hide()
	combat.hide()
	# show the buttons we do need
	fight.show()
	#defend.show()
	spell1.show()
	if State.level >= 5:
		spell2.show()
	if State.level >= 15:
		spell3.show()
	


	
func showOptions():
	flee.show()
	inv.show()
	combat.show()
	# show the buttons we do need
	fight.hide()
	defend.hide()
	spell1.hide()
	spell2.hide()
	spell3.hide()

# called when enemy or you dies
func endgame():
	var drops = State.enemies[enemy.enemy_type]["drops"].keys()
	print("getting drops")
	for drop in drops:
		State.update_inventory(drop,State.enemies[enemy.enemy_type]["drops"][drop])
		print(drop," added to inventory")
	State.cur_xp += round(pow(State.level,1.5)+State.level*2.6)
	var killed = get_node(NodePath(str('../enemies/',enemy.enemy_type)))
	print(killed)
	killed.set_defeat(1)
	get_tree().change_scene_to_file((str(State.prev_scene)))



func _on_flee_pressed():
	if yourTurn == 1:
		# hard coded right now to the only overworld map
		combat_end.emit()
		_ready()
		
		#get_tree().change_scene_to_file((str("res://scenes/levels/grimsBriar.tscn")))
	else:
		pass



func _on_combat_pressed():
	if yourTurn == 1:
		# hide buttons we don't need
		showAttacks()
	else:
		pass
	

func _on_inventory_pressed():
	if yourTurn == 1:
		flee.hide()
		inv.hide()
		combat.hide()
		inv_ui.show()
		exit_inv.show()
	
func _on_return_pressed():
	flee.show()
	inv.show()
	combat.show()
	# show the buttons we do need
	inv_ui.hide()
	exit_inv.hide()

func _on_onepunch_pressed():
	if yourTurn == 1:
		enemy.updateHealth(castSpell())
		eHealth.value = enemy.health
		print(enemy.health)
		yourTurn=0
		enemyTurn()
	else:
		pass
	


func _on_spell_pressed():
	pass # Replace with function body.


func _on_spell_1_item_selected(index):
	var list = spells.keys()
	State.spell1 = list[index]


func _on_spell_2_item_selected(index):
	var list = spells.keys()
	State.spell2 = list[index]


func _on_spell_3_item_selected(index):
	var list = spells.keys()
	State.spell3 = list[index]


func _on_enemy_combat_dead():
	combat_end.emit()
	death.emit()



func _on_inventory_ui_item_used():
	inv_ui.hide()
	yourTurn=0
	enemyTurn() 
	

