extends Node

# player vars
var prev_player_position
var prev_scene: NodePath
var engaging = []
var talking = 0
var p_locs = {}
var combat = 0
var enemyID:String


#weather vars
var is_raining = 0

# spell slots
var spell1: String = ''
var spell2: String = ''
var spell3: String = ''

# player gear slots
var helm: String = 'Watcher Cowl'
var chest: String = 'Watcher Robe'
var gloves: String = 'Watcher Gloves'
var pants: String = 'Watcher Trousers'
var boots: String = 'Watcher Treads'
var weapon: String = 'dagger of belonging' 
# the dagger can't be removed unless you take a life with it
# dagger is exceptionally dull as it can't be sharpened


# stats
var maxHealth: int = 99
var bonusMaxHealth: float = 1.0:
	set(value):
		bonusMaxHealth = value
		maxHealth = (bonusMaxHealth) * baseMaxHealth
var baseMaxHealth: int = 100:
	set(value):
		baseMaxHealth = value
		maxHealth = (bonusMaxHealth) * baseMaxHealth
var health: int = 100
var casts: int = 1
var shield
var cur_xp: int = 0
var xp_to_next: int = 10
var level: int = 1
var armor: int = 0 # physical resist
var mana: int = 25  # still not sure about mana usage
# var speed = 5
var crit_chance = 0 + (level/2+1)

# spell resists
var rFire: int = 0
var rFrost: int = 0
var rArcane: int = 0
var rBlood: int = 0
var rVoid: int = 0

# resources
var gold: int = 100

# social trackers
var welcomed: bool = 0
var witch_greeted: bool = 0

func _ready():
	maxHealth = baseMaxHealth + bonusMaxHealth


#connected signals
func _on_speak():
	pass

@onready var tutorials: Dictionary = {
	"Basics":{
		"text":str("Welcome to The Watcher's Curse! Move with W,A,S,D and", 
					"interact with objects or people using the F key! ",
					"As you level, you'll be able to unlock new spells and",
					" traits. These are found in the the 'Field Training' ",
					"portion of your Watcher's journal by pressing 'T'. Enjoy!"
				)
		,"seen":0
		}
}

# spell book and functions
@onready var spell_book = {
	"bloodThirst":{
		"name":"Blood Thirst",
		"description":"You reference your journal for critical weak points in similar foes",
		"learned":0,
		"damage":0,
		"class": "support",
		"type":"blood",
		"stat_mod":{
			"crit_chance":.2
			},
	},
	"barrier":{
		"name":"Barrier",
		"description":"You protect yourself from damage for 2 turns",
		"learned":0,
		"damage":0,
		"class": "defend",
		"stat_mod":{
			"armor":200 
			# each enemy attack will check if player armor is over 100
			# if armor is over 100 then the attack will remove 100 armor
			# this way defense spells with armor buffs don't need to count turns
		},
	},
	"fireball":{
		"name":"Fireball",
		"description":"",
		"learned":1,
		"aoe":0,
		"damage":20,
		"class": "attack",
		"type": "fire",
		"stat_mod":{
		},
	},
	"frostbolt":{
		"name":"Blizzard",
		"description":"",
		"learned":1,
		"aoe":0,
		"damage":10,
		"class": "attack",
		"type": "frost",
		"stat_mod":{
		},
	},
	"Sanguine Strings":{
		"name":"Sanguine Strings",
		"description":"Manipulate the blood flowing through your foe like a marionette and turn their
						aim inward.",
		"learned":1,
		"aoe":0,
		"damage":0,
		"class": "attack",
		"type": "blood",
		"stat_mod":{
		}
	}
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
@onready var inventory = {}

func update_inventory(item,amount):
	if inventory.has(item):
		inventory[item]+=amount
	else:
		inventory[item]=amount

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
		"quest_name":"Meet The Crowd",
		"Status":0,
		"Items":{
			beer=1,
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
		"quest_name":"Dirty Little Secret",
		"Status":0,
		"Items":{
			"Tims Notes":1
			},
		"description":"Artist's Intent"
	},
	"homebrewed":{
		"Giver":"front_desk",
		"quest_name":"Homebrewed",
		"Status":0,
		"Items":{
			"Void Goop":1,
			"berry bushel":1,
			"Bone Dust":1
		},
		"description":"You're in bat country and the visuals are kicking in. Time to find the goods."
	},
	"Trash_1":{
		"Giver":"TrashBoy",
		"quest_name":"Trash for the Trash God",
		"Status":0,
		"Items":{
			"Trash Food":4
		},
		"description":"Kindly bring Trash to the Trash God."
	},
	"witch_1":{
		"Giver":"witch",
		"quest_name":"Witch's Crew",
		"Status":0,
		"Items":{
			"plans":1
		},
		"description":"The techies are giving The Witch some trouble."
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

	

func update_quest_status(quest,status):
	quest_db[quest]["Status"]=status
	var items = quest_db[quest]["Items"]
	if status == 2:
		for item in items:
			inventory[item]-=int(quest_db[quest]["Items"][item])
		cur_xp += round(pow(State.level,1.5)+State.level*3.3)
		level_up()

func level_up():
	while cur_xp >= xp_to_next:
		cur_xp -= xp_to_next
		level += 1
		xp_to_next = round(pow(level,1.8) + level*4+2)
		baseMaxHealth += 10



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
	},
	"GB_tavern":{},
	"GB_inn":{},
	"starting_village":{},
	"GB_sewers":{},
	"WitchForest":{
		"1":0,
		"2":0,
		"3":0,
	},
	"energy_temple":{},
	"forest_cave":{}
}

# enemy DB
var enemies = {
	# dude got executed one day and has been hella salty and j haunts shit now
	"executioner":{
		"health":95,
		"speed":10,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":{
			"blood":10
		},
		"moves":{
			"basic":10,
			"special":25
		},
		"drops":{
			"Bone Dust":1
		}
	},
	# the highly volatile void squirrel. Best to kill it before it attacks
	"Void Squirrel":{
		"health":25,
		"speed":5,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":{
			"void":100
		},
		"moves":{
			"basic":10,
			"special":75
		},
		"drops":{
			"Void Goop":1
		}
	},
	"ghost":{
		"health":45,
		"speed":5,
		"defeated":0,
		"armor":0,
		"type": "void",
		"resists":{
			"void":100
		},
		"moves":{
			"basic":20,
			"special":45
		},
		"drops":{
			"Health Restore":1
		}
	}
}
# all vendors and what they sell
var Vendor_wares = {
	"GrimsBriar":{
		"Health Restore":{
			"inStock":99,
			"cost":5
		}
	}
}

# item rolodex
var items = {
	"Health Restore":{
		"type":"Potion",
		"effect":{
			"HP":40
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
