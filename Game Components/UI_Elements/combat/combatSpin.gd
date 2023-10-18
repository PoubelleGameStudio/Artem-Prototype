extends Node2D

@onready var rune1 = $rune1
@onready var rune2 = $rune2
@onready var rune3 = $rune3
@onready var rot1: float = 0.02
@onready var rot2: float = 0.025
@onready var rot3: float = 0.03
@onready var s_power: int
@onready var rune_stop = 1

# rune_align = 0 means the rune spins on ready. =1 means the rune is locked in
# runes are locked by spending the empowered rune points acrued during combat
@onready var rune1_align = 0
@onready var rune2_align = 0
@onready var rune3_align = 0

@export var rune1_mod: float
@export var rune2_mod: float
@export var rune3_mod: float


# Called when the node enters the scene tree for the first time.
func _ready():
	powerLevel(s_power)
	if Settings.accessibility_spell == 1:
		rot1 = 0.0
		rot2 = 0.0
		rot3 = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Spinning1(rot1)
	Spinning2(rot2)
	Spinning3(rot3)
	



	
		
	if Input.is_action_just_pressed("action"):
		if rune_stop == 1:
			print(rune_stop)
			rot1 = 0.0
			rune_stop +=1
			var refAngle1: float = getRefAngle(rune1.rotation_degrees)
			if refAngle1 > 180:
				rune1_mod = float(str(1-((360.0-refAngle1)/180)).pad_decimals(2))
				print("rune alignment ",rune1_mod)
			if refAngle1 < 180:
				rune1_mod = float(str(1-(refAngle1/180)).pad_decimals(2))
				print("rune alignment ",rune1_mod)
			
		elif rune_stop == 2:
			print(rune_stop)
			rot2 = 0.0
			rune_stop += 1
			var refAngle2: float = getRefAngle(rune2.rotation_degrees)
			if refAngle2 > 180:
				rune2_mod = float(str(1-((360.0-refAngle2)/180)).pad_decimals(2))
				print("rune alignment ",rune2_mod)
			if refAngle2 < 180:
				rune2_mod = float(str(1-(refAngle2/180)).pad_decimals(2))
				print("rune alignment ",rune2_mod)
			
		elif rune_stop == 3:
			print(rune_stop)
			rot3 = 0.0
			var refAngle3: float = getRefAngle(rune3.rotation_degrees)
			if refAngle3 > 180.0:
				rune3_mod = float(str(1-((360.0-refAngle3)/180)).pad_decimals(2))
				print("rune alignment ",rune3_mod)
			if refAngle3 < 180.0:
				rune3_mod = float(str(1-(refAngle3/180)).pad_decimals(2))
				print("rune alignment ",rune3_mod)

			
			
			
func Spinning1(rot):
	rune1.rotate(rot)
func Spinning2(rot):
	rune2.rotate(rot)
func Spinning3(rot):
	rune3.rotate(rot)


# handle power levels
func powerLevel(power):
	if power:
		match power:
			int(1):
				rune2.hide()
				rune3.hide()
			int(2):
				rune3.hide()
			int(3):
				pass
				
func getRefAngle(angle):
	var ref_angle: float = angle
	while ref_angle > 360.0:
		ref_angle -= 360
	print(ref_angle)
	return ref_angle
	
