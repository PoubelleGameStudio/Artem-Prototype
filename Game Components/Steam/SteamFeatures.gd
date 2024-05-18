extends Node

var STEAM_APP_ID: String = "2974630"

func _init():
	OS.set_environment("SteamAppId", STEAM_APP_ID)
	OS.set_environment("SteamGameId", STEAM_APP_ID)

func _ready():
	Steam.steamInit()
	print("steam running: ",Steam.isSteamRunning())
	

func setAchievement(ach) -> void:
	if Steam.getAchievement(ach)["achieved"]:
		print("already unlocked")
	else:
		Steam.setAchievement(ach)
		print(ach," unlocked")


	
#	var INIT: Dictionary = Steam.steamInit(false)
#	print("Did Steam initialize?: "+str(INIT))
