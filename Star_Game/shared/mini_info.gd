
extends Node2D
var name
var max_health
var health
var lbl_name
var lbl_health
var offset
var margin = 5

func _ready():
	lbl_health = get_node("lbl_health")
	lbl_name = get_node("lbl_name")
	name = get_parent().get_name()
	lbl_name.set_text(get_parent().get_name())
	var parent_rect = get_parent().get_item_rect()
	offset = Vector2(0, -parent_rect.size.height / 2)
	set_fixed_process(true)

func _fixed_process(delta):
	set_rot(-get_parent().get_rot())
	health = get_parent().health
	max_health = get_parent().max_health
	if health != max_health:
		lbl_health.set_text(str(round(health)) + ' / ' + str(round(max_health)))
#	set_pos(get_child(0).get_pos())
	lbl_health.set_pos(Vector2(lbl_health.get_pos().x,  -lbl_health.get_size().height - margin) + offset)
	lbl_name.set_pos(Vector2(lbl_name.get_pos().x, lbl_health.get_pos().y -lbl_name.get_size().height - margin))