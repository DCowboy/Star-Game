# info child for objects TODO: Replace health label with a health bar
extends Node2D
var max_health
var health
var lbl_name
var lbl_health
var offset
var margin = 5

func _ready():
	lbl_health = get_node("lbl_health")
	lbl_name = get_node("lbl_name")
	var parent_rect = get_parent().get_item_rect()
	offset = Vector2(0, -parent_rect.size.height / 2)
	set_process(true)

func _process(delta):
	set_rot(-get_parent().get_rot())
	health = get_parent().health
	max_health = get_parent().max_health
	if health != max_health:
		lbl_health.set_text(str(round(health)) + ' / ' + str(round(max_health)))
	lbl_health.set_pos(Vector2(lbl_health.get_pos().x,  -lbl_health.get_size().height - margin) + offset)
	lbl_name.set_pos(Vector2(lbl_name.get_pos().x, lbl_health.get_pos().y -lbl_name.get_size().height - margin))