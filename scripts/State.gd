extends Node

# player vars
var prev_player_position
var prev_scene: NodePath
var engaging = []
var talking = 0
var p_locs = {}
var combat : bool = false
var enemyID:String
var can_walk: bool = true
var can_use: bool = true
var shopping: bool = false


#weather vars
var is_raining = 0

# spell slots
var spell1: String = 'fireball'
var spell2: String = 'Hollowed Threats'
var spell3: String = 'Sanguinated Shell'
var spell4: String = 'Curse'
var spell5: String = 'Void Sight'
var spell6: String = 'Blood Clot Homunculus'


# player slots
var quick_slot_1 : String = ''
var quick_slot_2 : String
var quick_slot_3 : String
var quick_slot_4 : String = ''

#var helm: String = 'Watcher Cowl'
#var chest: String = 'Watcher Robe'
#var gloves: String = 'Watcher Gloves'
#var pants: String = 'Watcher Trousers'
#var boots: String = 'Watcher Treads'
#var weapon: String = 'dagger of belonging' 
# the dagger can't be removed unless you take a life with it
# dagger is exceptionally dull as it can't be sharpened


# stats
var maxHealth: int = 100
var bonusMaxHealth: float = 1.0:
	set(value):
		bonusMaxHealth = value
		maxHealth = (bonusMaxHealth) * baseMaxHealth
var baseMaxHealth: int = 100:
	set(value):
		baseMaxHealth = value
		maxHealth = (bonusMaxHealth) * baseMaxHealth
var health: int = maxHealth
var casts: int = 1
var shield
var cur_xp: int = 0
var xp_to_next: int = 10
var level: int = 20
var armor: int = 0 # physical resist
var mana: int = 1  # still not sure about mana usage
# var speed = 5
var crit_chance = 0 + (level/2+1)

# spell resists
var rFire: int = 0
var rFrost: int = 0
var rArcane: int = 0
var rBlood: int = 0
var rVoid: int = 0

# resources
var gold: int = 50
var ability_points: int = 30

# social trackers
var welcomed: bool = false
var witch_greeted: bool = 0
var world: String
var met_stw: bool = false

# setting configs
var mute_sound: bool = false
var hide_control_hints: bool = false
var combat_music_slider_value: int = 0
var world_music_slider_value: int = 0
var control_schema: String = "gamepad"


func _ready():
	maxHealth = baseMaxHealth + bonusMaxHealth
	check_for_new_spells()
	check_for_new_traits()


func shop_handler() -> void:
	get_node("/root/root/player").shop_handler()

# talents
@onready var t_HP: bool = false: #increase HP by 10%
	set(value):
		var old_val = t_HP
		if old_val != value:
			t_HP = value
			bonusMaxHealth += .1

@onready var t_attack_up: bool = false: #increase damage
	set(value):
		var old_val = t_attack_up
		if old_val != value:
			t_attack_up = value

@onready var t_extra_cast: bool = false: #cast a 2nd spell each turn
	set(value):
		var old_val = t_extra_cast
		if old_val != value:
			t_extra_cast = value
			casts += 1

@onready var t_shield: bool = false: #reduce damage taken
	set(value):
		var old_val = t_shield
		if old_val != value:
			t_shield = value

@onready var t_kindling: bool = false: #increase fire damage
	set(value):
		var old_val = t_kindling
		if old_val != value:
			t_kindling = value

@onready var t_curse: bool = false: #
	set(value):
		var old_val = t_curse
		if old_val != value:
			t_curse = value
			spell_book["Curse"]["learned"] = 1
			
@onready var t_poison_swamp: bool = false: #
	set(value):
		var old_val = t_poison_swamp
		if old_val != value:
			t_poison_swamp = value
			spell_book["Poison Swamp"]["learned"] = 1

@onready var t_hollowed_threats: bool = false:
	set(value):
		var old_val = t_hollowed_threats
		if old_val != value:
			t_hollowed_threats = value
			spell_book["Hollowed Threats"]["learned"] = 1
			
@onready var t_void_sight: bool = false:
	set(value):
		var old_val = t_void_sight
		if old_val != value:
			t_void_sight = value
			spell_book["Void Sight"]["learned"] = 1

@onready var t_vapid_affliction: bool = false:
	set(value):
		var old_val = t_vapid_affliction
		if old_val != value:
			t_vapid_affliction = value
			spell_book["Vapid Affliction"]["learned"] = 1
			
@onready var t_sanguinated_shell: bool = false:
	set(value):
		var old_val = t_sanguinated_shell
		if old_val != value:
			t_sanguinated_shell = value
			spell_book["Sanguinated Shell"]["learned"] = 1
			
@onready var t_blood_clot_homunculus: bool = false:
	set(value):
		var old_val = t_blood_clot_homunculus
		if old_val != value:
			t_blood_clot_homunculus = value
			spell_book["Blood Clot Homunculus"]["learned"] = 1
			
@onready var t_blood_moon: bool = false:
	set(value):
		var old_val = t_blood_moon
		if old_val != value:
			t_blood_moon = value
			spell_book["Blood Moon"]["learned"] = 1

@onready var tutorials: Dictionary = {
	"Welcome!":{
		"text":str("Welcome to The Watcher's Curse demo! Pres ESC on your keyboard",
					" or START on your gamepad to see controls. In this demo you'll play through",
					" one of the many quest narratives from the full version of the game. Take your",
					" time exploring and reveal the true evil closing in on Artem. Enjoy :)"
				)
		,"seen":0
		},
	"Stats":{
		"text":str("These are your stats! Check your health, gold, level, and XP here.")
		,"seen":0
	},
	"Quick Slots":{
		"text":str("These are your quick slots! You can assign items from your inventory to",
					" each slot by hovering over an item and pressing the corresponding slot",
					" number. Controller players will need to press the corresponding d-pad direction.")
		,"seen":0
	},
	"Quest Log":{
		"text":str("This is your quest log! Check how you're progressing!")
		,"seen":0
	},
	"talents_1":{
		"text":str("Welcome to the skills and traits page! Click a skill or trait to see what it does ",
					"and when you will unlock it.")
		,"seen":0
	}
}

# spell book and functions
@onready var spell_book = {
	"Sanguinated Shell":{
		"name":"Sanguinated Shell",
		"description":"Coalesce your blood into a hardened shell absorbing 30% damage for 3 turns. When the shell expires you heal for half the amount absorbed.",
		"learned":0,
		"level":1,
		"damage":0,
		"class": "defend",
		"type":"blood",
		"stat_mod":{}
	},
	"Blood Clot Homunculus":{
		"name":"Blood Clot Homunculus",
		"description":"Sacrifice 20% of your health to construct a blood clot homunculus that will copy your attacks for 20% of the damage done.",
		"learned":0,
		"level":5,
		"damage":0,
		"class": "summon",
		"type": "blood",
		"stat_mod":{}
	},
	"Blood Moon":{
		"name":"Blood Moon",
		"description":"Increase the effects of all blood magic by 20% for 3 turns.",
		"learned":0,
		"level":10,
		"damage":0,
		"class": "field",
		"type": "blood",
		"stat_mod":{}
	},
	"fireball":{
		"name":"Fireball",
		"description":"A technique, taught to you by a bearded flamethrower, that blasts your opponent with concentrated fire.",
		"learned":1,
		"level":0,
		"damage":10,
		"class": "attack",
		"type": "Fire",
		"stat_mod":{},
	},
	"Hollowed Threats":{
		"name":"Hollowed Threats",
		"description":"Seep your opponent in void energy weakening their attack by 20%",
		"learned":0,
		"level":1,
		"damage":0,
		"class": "attack",
		"type": "Void",
		"stat_mod":{},
	},
	"Void Sight":{
		"name":"Void Sight",
		"description":"Look through the void to anticipate your oppoents attacks. Increase chance to dodge by 15% for 3 turns.",
		"learned":0,
		"level":5,
		"damage":0,
		"class": "attack",
		"type": "Void",
		"stat_mod":{},
	},
	"Vapid Affliction":{
		"name":"Vapid Affliction",
		"description":"The void invades your foe's mind. Each turn they have an increasing chance to not attack on their next turn.",
		"learned":0,
		"level":10,
		"damage":0,
		"class": "attack",
		"type": "Void",
		"stat_mod":{},
	},
	"Curse":{
		"name":"Curse",
		"description":"Chaos entangled matter attacks the soul directly.",
		"learned":0,
		"level":5,
		"damage":15,
		"class": "attack",
		"type": "Void",
		"stat_mod":{}
	},
	"Poison Swamp":{
		"name":"Poison Swamp",
		"description":"Seep the ground beneath your foes feet in thick, poisonous sludge",
		"learned":0,
		"level":10,
		"damage":10,
		"class": "attack",
		"type": "Poison",
		"stat_mod":{}
	},
}

func check_for_new_traits() -> void:
	for t in traits:
		if traits[t]["level"] <= level and traits[t]["learned"] == 0:
			traits[t]["learned"] = 1
			match t:
				"HP+": 
					t_HP = true
				"Attack+": 
					t_attack_up = true
				"Extra Action": 
					t_extra_cast = true
					casts = 2
				"Shield+": 
					t_shield = true
#traits
@onready var traits = {
	"HP+":{
		"name":"HP+",
		"description":"Your fortitude has never been so powerful.",
		"learned":0,
		"level":10,
		},
	"Attack+":
		{"name":"Attack+",
		"description":"Increase your damage output even further.",
		"learned":0,
		"level":20,
		},
	"Extra Action":
		{"name":"Extra Action",
		"description":"Through experience and training you're able to attack twice before foes react.",
		"learned":0,
		"level":5,
		},
	"Shield+":
		{"name":"Shield+",
		"description":"Could be callouses, could be nerve damage, but you can take more hits.",
		"learned":0,
		"level":15
		},
}

func learn_spell(spell,cost,damage,stat_mod,stat_mod_amt,stat_req,stat_req_amt):
	spell_book[spell]={
		"cost":cost,
		"damage":damage,
		"stat_mod":{
			stat_mod:stat_mod_amt
			},
		"stat_req":{
			stat_req:stat_req_amt
			}
	}

#quest item inventory
@onready var q_inventroy = {"Cursed Book":1}

# personal inventory and functions
@onready var inventory = {
	"health restore":2
}

func update_inventory(item,amount):
	if inventory.has(item):
		inventory[item]+=amount
	else:
		inventory[item]=amount



func check_inv(item) -> int :
	if inventory.has(item) :
		if inventory[item] :
			return inventory[item]
	return 0
	

func populate_last_enemy_defeated(name: String, loot: String, xp_gained: String) -> void:
	last_enemy_defeated["name"] = str("Defeated: ",name)
	last_enemy_defeated["loot"] = str("Looted:\n",loot)
	last_enemy_defeated["xp_gained"] = str("XP: ",xp_gained)
	
	
var last_enemy_defeated = {
	"name":""
	,"loot":""
	,"xp_gained":""
}

# quest status -1:unavailable 0:inactive 1:active 2:completed
# array of quests
var quest_db ={
	"beer_run":{
		"giver":"beer_run",
		"quest_name":"Pass the Bottle",
		"Status":0,
		"Items":{
			bottle=1
			},
		"description":"Your new acquaintance has asked for a night cap."
	},
	"barkeep_1":{
		"giver":"barkeep",
		"quest_name":"Make Some Friends",
		"Status":0,
		"Items":{
			"beer"=1,
			"Grims Briar Room Key"=1
			},
		"description":"Grab some creature comforts."
	},
	"barkeep_2":{
		"giver":"barkeep",
		"quest_name":"Harsh the buzz",
		"Status":0,
		"Items":{
			"get me down potion":1
			},
		"description":"Surely, the old man will be helpful..."
	},
	"barkeep_3":{
		"giver":"barkeep",
		"quest_name":"Violent Delights",
		"Status":0,
		"Items":{
			"Tim's Lament":1
			},
		"description":"Find where Tim has been hiding."
	},
	"homebrewed":{
		"Giver":"front_desk",
		"quest_name":"Homebrewed",
		"Status":0,
		"Items":{
			"Void Goop":1,
			"berries":1,
			"Bone Dust":1
		},
		"description":"You're in bat country."
	},
	"Trash_1":{
		"Giver":"TrashBoy",
		"quest_name":"Trash for the Trash God",
		"Status":0,
		"Items":{
			"trash food":4
		},
		"description":"Kindly bring 4 servings trash foods to the Trash God."
	},
	"witch_1":{
		"Giver":"witch",
		"quest_name":"Witch's Crew",
		"Status":0,
		"Items":{
			"Burden of Knowledge":1
		},
		"description":"Investigate the Technotheists' temple."
	}
	
}

# various quest progress trackers
var given_ingredients = 0 #barkeep_1 progress

func quest_complete(quest) -> bool:
	var items = quest_db[quest]["Items"]
	var req_met: bool
	if inventory:
		for item in items:			
			if inventory.has(item):
				if (int(quest_db[quest]["Items"][item])<=int(inventory[item])):
					req_met = true				
				else:
					req_met = false
				
			else:
				req_met =  false
							
	else:
		req_met =  false
	return req_met

	

func update_quest_status(quest,status) -> void:
	quest_db[quest]["Status"]=status
	var items = quest_db[quest]["Items"]
	if status == 2:
		for item in items:
			inventory[item]-=int(quest_db[quest]["Items"][str(item)])
		cur_xp += round(pow(State.level,2.5)+State.level*2)
		level_up()



func level_up():
	while cur_xp >= xp_to_next:
		cur_xp -= xp_to_next
		level += 1
		mana += 1
		ability_points += 1
		xp_to_next = round(pow(level,1.8) + level*4+2)
		baseMaxHealth += 10
		if level % 5 == 0:
			check_for_new_spells()
			check_for_new_traits()


func check_for_new_spells() -> void:
	# check for any spells that can be unlocked
	for spell in spell_book:
		if spell_book[spell]["level"] <= level and spell_book[spell]["learned"] == 0:
			spell_book[spell]["learned"] = 1
			print("learned ",spell_book[spell])

	

#control what enemies in what zone have been defeated
var area_enemies = {
	"title_screen":{},
	"grimsBriar":{
		"1":0,
		"2":0,
		"3":0,
		"4":0,
		"5":0,
		"6":0,
		"7":0,
		"8":0
	},
	"GB_tavern":{},
	"GB_inn":{},
	"starting_village":{},
	"GB_sewers":{},
	"WitchForest":{
		"1":0,
		"2":0,
		"3":0,
		"4":0,
		"5":0,
		"6":0,
		"7":0,
		"8":0
	},
	"energy_temple":{
		"1":0,
		"2":0,
		"3":0,
		"4":0,
		"5":0,
		"6":0,
		"7":0,
		"8":0,
		"9":0,
		"10":0,
		"11":0
	},
	"forest_cave":{
		"1":0,
		"2":0,
		"3":0,
		"4":0,
		"5":0,
		"6":0,
		"7":0
	},
	"mourning_fields":{
		"1":0
	}
}

# enemy DB
var enemies = {
	# dude got executed one day and has been hella salty and j haunts shit now
	"executioner":{
		"health":250,
		"faction":"Void",
		"speed":10,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":"blood",
		"moves":{
			"basic":10,
			"special":25
		},
		"drops":{
			"Bone Dust":1
		},
		"lore":"Executioners are no common, rage filled spirit. They are summoned from the void and bound to kingdoms. When the kingdom falls, the executioners roam the land cutting down all in their path."
	},
	# the highly volatile void squirrel. Best to kill it before it attacks
	"Void Squirrel":{
		"health":25,
		"faction":"Void",
		"speed":5,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":"void",
		"moves":{
			"basic":10,
			"special":75
		},
		"drops":{
			"Void Goop":1
		},
		"lore":"A small critter that at some point came into contact with a source of void energy. They're still just a rodent, but now occasionally they lash out dealing near fatal damage."
	},
	"ghost":{
		"health":55,
		"faction":"Spirit",
		"speed":5,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":"void",
		"moves":{
			"basic":20,
			"special":45
		},
		"drops":{
			"health restore":1
		},
		"lore":"By all accounts ghosts are your run of the mill spirits. Often tied to the land or structure by some emotion. If they weren't so violent you could just leave them be."
	},
	"Technotheist Grunt":{
		"health":55,
		"faction":"Technotheist",
		"speed":5,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":"void",
		"moves":{
			"basic":20,
			"special":45
		},
		"drops":{
			"health restore":1
		},
		"lore":"A radicalized citizen of the Needle now warped by technotheological propaganda. Their quest for purity in the eye of their god has lead them to commit attrocities against their own."
	},
	"Ascended Technotheist":{
		"health":400,
		"faction":"Technotheist",
		"speed":5,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":"void",
		"moves":{
			"basic":25,
			"special":55
		},
		"drops":{
			"health restore":5
		},
		"lore":"A high ranking member of the technotheist theocratic structure. Having reached a form of pure technology the ascended no longer resemble any form of human."
	},
	"Sorrow Shade":{
		"health":45,
		"faction":"Spirit",
		"speed":5,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":"Curse",
		"moves":{
			"basic":20,
			"special":20,
		},
		"drops":{
			"health restore":2
		},
		"lore":"Created when a living being dies a truly horrific death. In their final moments, realizing their fate, the soul turns vengeful and fills with hatred. They also tends to attract nearby shades."
	}
}
# all vendors and what they sell
var Vendor_wares = {
	"GrimsBriar":{
		"health restore":{
			"inStock":99,
			"cost":5
		}
	}
}

# item rolodex
var items = {
	"health restore":{
		"type":"Potion",
		"effect":60
	},
	"beer":{
		"type":"Potion",
		"effect":20
	},
	"rip'd cd":{
		"type":"Throwable",
		"effect":{
			"damage": 55
		}
	}
}

# gear rolodex
var gear = {
	"dagger_of_belonging":{
		"name": "Dagger of Belonging",
		"Description": "Once held, you can not discard the dagger until it takes a life.
							The blade cannot be sharpened and it wears duller with every kill.
							If you attempt to use any other weapon, you will find the dagger of 
							belonging suddenly plunged deep in the center of your heart.",
		"Damage": 1,
		"type": "dagger"
	}
}
