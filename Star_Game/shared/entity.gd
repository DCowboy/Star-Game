
extends Node2D
var max_health
var health
var lbl_health


func _ready():
	lbl_health = get_child(1)
	max_health = get_child(0).max_health
	set_process(true)
	lbl_health
	

func _process(delta):
	health = get_child(0).get('health')
	if health != max_health:
		lbl_health.set_text(str(health) + ' / ' + str(max_health))
	set_pos(get_child(0).get_pos())
	lbl_health.set_pos(get_child(0).get_pos() + Vector2(lbl_health.get_pos().x,  -get_child(0).get_child(0).get_item_rect().size.height / 2 - lbl_health.get_size().height))
	