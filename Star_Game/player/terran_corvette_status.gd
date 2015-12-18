
extends Node2D

var pwr = 6 setget pwr_set, pwr_get
var def = 1 setget def_set, def_get
var spd = 5 setget spd_get, spd_get
var display

func _ready():
	display = get_parent().get_parent()
	display.get_node('propulsion').set_text(str(spd))
	display.get_node('defense').set_text(str(def))
	display.get_node('weap_pwr').set_text(str(pwr))
	pass


func pwr_set(new_value):
	pwr = new_value
	
	
func pwr_get():
	return pwr
	
	
func def_set(new_value):
	def = new_value
	

func def_get():
	return def
	

func spd_set(new_value):
	spd = new_value
	
	
func spd_get():
	return spd