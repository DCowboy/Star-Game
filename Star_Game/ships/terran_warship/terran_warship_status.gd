#need to fix
extends Node2D

var weapons = 5 setget weapons_set, weapons_get
var core = 7 setget core_set, core_get
var engineering = 3 setget engineering_set, engineering_get
var display

func _ready():
	print('getting ready')
	display = get_parent().get_parent()
	print(display.get_name())
	display.get_node('engineering').set_text(str(engineering))
	display.get_node('core').set_text(str(core))
	display.get_node('weapons').set_text(str(weapons))
	display.get_node('supply').set_text(str(ceil((engineering + core) * .5)))
	display.get_node('tactical').set_text(str(ceil((engineering + weapons) * .5)))
	display.get_node('defense').set_text(str(ceil((core + weapons) * .5)))
	pass


func weapons_set(new_value):
	weapons = new_value
	
	
func weapons_get():
	return weapons
	
	
func core_set(new_value):
	core = new_value
	

func core_get():
	return core
	

func engineering_set(new_value):
	engineering = new_value
	
	
func engineering_get():
	return engineering