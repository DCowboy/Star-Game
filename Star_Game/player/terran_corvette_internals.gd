
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_parent().size = 1
	engines_disengage()
	pass


func engines_engage():
	get_node("burner_left").set_emitting(true)
	get_node("burner_right").set_emitting(true)
	
func engines_disengage():
	get_node("burner_left").set_emitting(false)
	get_node("burner_right").set_emitting(false)





