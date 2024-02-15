extends MarginContainer
class_name spell_button

@onready var selected: Sprite2D = $selected
@onready var button: Button = $Button
@onready var spell_label: Label = $spell_name

@export var spell_icon: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	button.icon = load(str("res://Sprites/combat/spell icons/",spell_icon,".png"))
	spell_label.text = spell_icon
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	State.spell1 = spell_icon


func _on_button_mouse_entered():
	spell_label.show()
	selected.show()
	

func _on_button_mouse_exited():
	spell_label.hide()
	selected.hide()
