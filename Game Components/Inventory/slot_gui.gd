extends Panel

@export var item_name = ""
@export var amount = 0

@onready var inv = State.inventory
@onready var amountLabel = $amount
@onready var itemArt = $itemArt
@onready var opt_show = 0
@onready var tooltip: TextureRect = $tooltip


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
		$tooltip/hoverName.text = item_name
		$tooltip/hoverDesc.text = State["items"][item_name]["description"]
	else:
		pass
	
	if amount == 0:
		inv.erase(item_name)
		$tooltip/hoverName.text = ""
		$tooltip/hoverDesc.text = ""
		item_name = ""
		amount -= 1
		amountLabel.text = ""
		itemArt.set_texture(null)
	

	hover_check()

func check_for_swap(item : String,slot : int) -> void : 
	
	var new_item : String = item
	
	match new_item : 
		State.quick_slot_1:
			print("need to swap to slot 1")
			State.quick_slot_1 = new_item
			match slot:
				2 : 
					if !State.quick_slot_2:
						State.quick_slot_1 = ''
					else:
						State.quick_slot_1 = State.quick_slot_2
				3 :
					if !State.quick_slot_3:
						State.quick_slot_1 = ''
					else:
						State.quick_slot_1 = State.quick_slot_3
				4 :
					if !State.quick_slot_4:
						State.quick_slot_1 = ''
					else:
						State.quick_slot_1 = State.quick_slot_4
		State.quick_slot_2:
			print("need to swap to slot 2")
			State.quick_slot_2 = new_item
			match slot:
				1 : 
					if !State.quick_slot_1:
						State.quick_slot_2 = ''
					else:
						State.quick_slot_2 = State.quick_slot_1
				3 :
					if !State.quick_slot_3:
						State.quick_slot_2 = ''
					else:
						State.quick_slot_2 = State.quick_slot_3
				4 :
					if !State.quick_slot_4:
						State.quick_slot_2 = ''
					else:
						State.quick_slot_2 = State.quick_slot_4
		State.quick_slot_3:
			print("need to swap to slot 3")
			State.quick_slot_3 = new_item
			match slot:
				2 : 
					if !State.quick_slot_2:
						State.quick_slot_3 = ''
					else:
						State.quick_slot_3 = State.quick_slot_2
				1 :
					if !State.quick_slot_1:
						State.quick_slot_3 = ''
					else:
						State.quick_slot_3 = State.quick_slot_1
				4 :
					if !State.quick_slot_4:
						State.quick_slot_3 = ''
					else:
						State.quick_slot_3 = State.quick_slot_4
		State.quick_slot_4:
			print("need to swap to slot 4")
			State.quick_slot_4 = new_item
			match slot:
				2 : 
					if !State.quick_slot_2:
						State.quick_slot_4 = ''
					else:
						State.quick_slot_4 = State.quick_slot_2
				3 :
					if !State.quick_slot_3:
						State.quick_slot_4 = ''
					else:
						State.quick_slot_4 = State.quick_slot_3
				1 :
					if !State.quick_slot_1:
						State.quick_slot_4 = ''
					else:
						State.quick_slot_4 = State.quick_slot_1
	
	pass

func hover_check():
	if $Button.is_hovered() or has_focus():
		
		if Input.is_action_just_pressed("quick_slot_1"):
			check_for_swap(item_name,1)
			State.quick_slot_1 = item_name
			get_node("../../../Quick Slots").setup()
			
		if Input.is_action_just_pressed("quick_slot_2"):
			check_for_swap(item_name,2)
			State.quick_slot_2 = item_name
			get_node("../../../Quick Slots").setup()
			
		if Input.is_action_just_pressed("quick_slot_3"):
			check_for_swap(item_name,3)
			State.quick_slot_3 = item_name
			get_node("../../../Quick Slots").setup()
			
		if Input.is_action_just_pressed("quick_slot_4"):
			check_for_swap(item_name,4)
			State.quick_slot_4 = item_name
			get_node("../../../Quick Slots").setup()
			
		
		if Input.is_action_pressed("drop_inv_item"):
			inv.erase(item_name)
			item_name = ""
			amount -= 1
			amountLabel.text = ""
			itemArt.set_texture(null)
	
		if Input.is_action_just_released("use_inv_item"):
			if State.items.has(item_name):
				match State.items[item_name]["type"]:
					"Potion":
						if State.health < State.maxHealth:
							if State.maxHealth && (State.health + State.items[item_name]["effect"]) > State.maxHealth:
								State.health = State.maxHealth
								inv[item_name]-=1
								item_used.emit()
							else:
								State.health += State.items[item_name]["effect"]
								inv[item_name]-=1
								item_used.emit()
							
							
							
func _on_button_mouse_entered():
	self.has_focus()
	$indicator.show()
	if item_name:	
		tooltip.show()
	
	

func _on_button_mouse_exited():
	tooltip.hide()
	$indicator.hide()

			
			
			
func _on_focus_entered():
	$indicator.show()
	if item_name:	
		tooltip.show()


func _on_focus_exited():
	$indicator.hide()
	tooltip.hide()
