extends MarginContainer
class_name spell_button

@onready var selected: Sprite2D = $selected
@onready var button: Button = $Button

@export var spell_icon: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	button.icon = load(str("res://Sprites/combat/spell icons/",spell_icon,".png"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	State.spell1 = spell_icon


func _on_button_mouse_entered():
	selected.show()
	

func _on_button_mouse_exited():
	selected.hide()
