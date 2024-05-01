extends Node

var STEAM_APP_ID: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _initialize_Steam():
	OS.set_environment("SteamAppId", str(STEAM_APP_ID))
	OS.set_environment("SteamGameId", str(STEAM_APP_ID))
	
#	var INIT: Dictionary = Steam.steamInit(false)
#	print("Did Steam initialize?: "+str(INIT))
