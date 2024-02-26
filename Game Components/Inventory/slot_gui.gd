extends Panel

@export var item_name = ""
@export var amount = 0

@onready var inv = State.inventory
@onready var amountLabel = $amount
@onready var itemArt = $itemArt
@onready var opt_show = 0


#signal
signal item_used


# Called when the node enters the scene tree for the first time.
func _ready():
	if item_name and inv.has(item_name):
		amount = inv[item_name]
		amountLabel.text = str(amount)
		var artRes = load(str("res://Art/inv_Art/",item_name,".png"))
		itemArt.show()
		itemArt.set_texture(artRes)
		$hoverName.text = item_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if item_name and inv.has(item_name):
		amount = inv[item_name]
		amountLabel.text = str(amount)
		var artRes = load(str("res://Art/inv_Art/",item_name,".png"))
		itemArt.show()
		itemArt.set_texture(artRes)
		$hoverName.text = item_name
	else:
		pass
	
	if amount == 0:
		inv.erase(item_name)
		$hoverName.text = ""
		item_name = ""
		amount -= 1
		amountLabel.text = ""
		itemArt.set_texture(null)
	

	hover_check()


func _on_button_mouse_entered():
	#$indicator.show()
	$hoverName.show()
	

func _on_button_mouse_exited():
	#$indicator.hide()
	$hoverName.hide()


func hover_check():
	if $Button.is_hovered():
		if Input.is_action_pressed("drop_inv_item"):
			inv.erase(item_name)
			$hoverName.text = ""
			item_name = ""
			amount -= 1
			amountLabel.text = ""
			itemArt.set_texture(null)
		if Input.is_action_just_released("use_inv_item"):
			if State.items.has(item_name):
				match State.items[item_name]["type"]:
					"Potion":
						if State.health < State.maxHealth:
							if State.maxHealth && (State.health + State.items[item_name]["effect"]['HP']) > State.maxHealth:
								State.health = State.maxHealth
								inv[item_name]-=1
								item_used.emit()
							else:
								State.health += State.items[item_name]["effect"]['HP']
								inv[item_name]-=1
								item_used.emit()
							
					


	
