
extends RigidBody2D

var name = 'laser_shot'
var direction
var acceleration
var shot_acceleration = 100
var payload = 25
var exploding = false
var life = 0
export var lifetime = 90
var sound

func _ready():
	acceleration += shot_acceleration
	sound = get_node("/root/globals").sound_effects.instance()
	add_child(sound)
	sound.play('laser')
	set_fixed_process(true)


func _integrate_forces(state):
	life += 1
	var count = state.get_contact_count()
	if count > 0:
		var collider = state.get_contact_collider_object(0)
		if collider != null and collider.get_name() != 'player':
			hit_by(collider)
			collider.hit_by(self)
			
	if exploding or life >= lifetime:
		set_linear_velocity(Vector2(0, 0))
		#setting explosion
		get_node("Sprite").hide()
		var explode = get_node("/root/globals").explosions.small_normal.instance()
		explode.set_pos(get_pos())
		call_deferred('replace_by', explode)
	else:
		if get_linear_velocity().length() <= acceleration:
			apply_impulse(Vector2(0, 0), direction * acceleration)


func hit_by(obj):
	if not exploding:
		if obj != null and obj.get_type() == 'RigidBody2D':
			if obj.name == 'laser_shot' or obj.health > 0:
				obj.set_applied_force(direction * (acceleration + payload))

	exploding = true

