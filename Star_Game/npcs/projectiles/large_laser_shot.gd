#need to fix
extends RigidBody2D
var owner
var name = 'laser_shot'
var direction
var acceleration
var shot_acceleration = 500
var origin
var fire_range
var payload
var exploding = false


var sound

func _ready():
	shot_acceleration += acceleration
	sound = get_node("/root/globals").sound_effects.instance()
	add_child(sound)
	sound.play('laser')
	set_fixed_process(true)
	
func _fixed_process(delta):
	if abs(Vector2(get_pos() - origin).length()) >= fire_range: 
		exploding = true
	if exploding:
		set_linear_velocity(Vector2(0, 0))
		#setting explosion
		get_node("Sprite").free()
		var explode = get_node("/root/globals").explosions.large_normal.instance()
		explode.set_pos(get_pos())
		call_deferred('replace_by', explode)
	else:
		if get_linear_velocity().length() <= shot_acceleration:
			apply_impulse(Vector2(0, 0), direction * shot_acceleration)

func _integrate_forces(state):
	var count = state.get_contact_count()
	if count > 0:
		var collider = state.get_contact_collider_object(0)
		if collider.name != 'player':
			hit_by(collider)
			collider.hit_by(self, state.get_contact_collider_shape(0))
			

func hit_by(obj, at=null):
	if not exploding:
		if obj != null and obj.get_type() == 'RigidBody2D':
			if obj in get_tree().get_nodes_in_group('projectiles'):
				obj.set_applied_force(direction * (shot_acceleration + payload))
	exploding = true

