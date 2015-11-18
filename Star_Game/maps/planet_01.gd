
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	#quick and dirty fix to trigger boundry issue
	get_parent().get_node('area_map')._on_bottom_right_body_enter( self )
	pass


