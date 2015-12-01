
extends Particles2D
var sound


func _ready():
	if str(get_name()).find('small_explosion') != -1:
		sound = get_node("/root/globals").sound_effects.instance()
		add_child(sound)
		sound.play('small_explosion', 0)
	set_emitting(true)
	set_process(true)
	

func _process(delta):
	if not is_emitting(): # or sound == null or not sound.is_voice_active(0):
#		if get_node("SamplePlayer2D") != null:
#			get_node("SamplePlayer2D").stop_voice(0)
		queue_free()