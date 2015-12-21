
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_parent().size = 1
	engines_disengage()
	pass


func engines_engage():
	get_node("burner_center").set_emitting(true)
	
func engines_disengage():
	get_node("burner_center").set_emitting(false)


