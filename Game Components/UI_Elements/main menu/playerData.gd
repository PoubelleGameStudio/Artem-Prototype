extends Resource
class_name PlayerData

# player vars
@export var prev_scene: String
@export var engaging: Array
@export var talking: bool
@export var p_locs: Dictionary
@export var combat: bool
@export var enemyID:String
@export var playerCoords: Vector2
@export var world: String
@export var pos: Vector2


#weather vars
@export var is_raining: bool

# spell slots
@export var spell1: String
@export var spell2: String
@export var spell3: String

# player items
@export var player_inv: Dictionary
@export var helm: String
@export var chest: String
@export var gloves: String
@export var pants: String
@export var boots: String
@export var weapon: String

# stats
@export var maxHealth: int
@export var bonusMaxHealth: int
@export var baseMaxHealth: int
@export var health: int
@export var cur_xp: int
@export var xp_to_next: int
@export var level: int
@export var armor: int # physical resist
@export var mana: int# still not sure about mana usage
@export var crit_chance: int
@export var talents: Dictionary

# spell resists
@export var rFire: int
@export var rFrost: int
@export var rArcane: int
@export var rBlood: int
@export var rVoid: int

# resources
@export var gold: int

# social trackers
@export var welcomed: bool
@export var witch_greeted: bool

# world progress
@export var quest_db: Dictionary
@export var area_enemies: Dictionary
@export var Vendor_wares: Dictionary
@export var tutorials: Dictionary

