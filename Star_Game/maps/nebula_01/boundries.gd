
extends ReferenceFrame

var map_size 
var mirrors = {}


func add_mirrors(object, offsets, edge_name):
	var copies = {}
	var images = []
	var parent = object
	for offset in offsets:
		var new_sprite = Sprite.new()
		if object.get_type() in ['KinematicBody2D', 'RigidBody2D', 'StaticBody2D', 'Area2D']:
			new_sprite.set_texture(object.get_child(0).get_texture())
			new_sprite.set_region(true)
			new_sprite.set_region_rect(object.get_child(0).get_region_rect())
		else:
			new_sprite.set_texture(object.get_texture())
		new_sprite.set_scale(object.get_scale())
		new_sprite.set_pos(object.get_pos() + offset)
		new_sprite.set_rot(object.get_rot())
		get_parent().add_child(new_sprite)
		images.append(new_sprite)
	copies['parent'] = parent
	copies['images'] = images
	copies['offsets'] = offsets
	mirrors[object.get_name() + edge_name] = copies


func remove_mirrors(name, edge):
	for image in mirrors[name + edge].images:
		image.free()
	mirrors.erase(name + edge)

func update_mirrors():
	for mirror in mirrors:
		var pos = mirrors[mirror].parent.get_pos()
		var index = 0
		for image in mirrors[mirror].images:
			image.set_pos(pos + mirrors[mirror].offsets[index])
			index += 1


func check_bounds():
	for obj in mirrors:
		var pos = mirrors[obj].parent.get_pos()
		var new_pos = mirrors[obj].parent.get_pos()
		if pos.x <= -map_size.size.width / 2 + 1:
			new_pos.x = map_size.size.width / 2 - 1
		elif pos.x >= map_size.size.width / 2 - 1:
			new_pos.x = -map_size.size.width / 2 + 1
		if pos.y <= -map_size.size.height / 2 + 1:
			new_pos.y = map_size.size.height / 2 - 1
		elif pos.y >= map_size.size.height / 2 - 1:
			new_pos.y = -map_size.size.height / 2 + 1

		if pos != new_pos:
			mirrors[obj].parent.set_pos(new_pos)


func _fixed_process(delta):
	update_mirrors()
	check_bounds()
	
	
func make_edge(loc):
	
	pass

func _ready():
	map_size = get_item_rect()
	
	set_fixed_process(true)

func _on_top_left_body_enter( body ):
	var name = 'top_left'
	var offsets = [Vector2(0, map_size.size.height),
		Vector2(map_size.size.width, map_size.size.height),
		Vector2(map_size.size.width, 0)]
	add_mirrors(body, offsets, name)


func _on_top_left_body_exit( body ):
	var obj_name = body.get_name()
	var name = 'top_left'
	remove_mirrors(obj_name, name)


func _on_top_center_body_enter( body ):
	var name = 'top_center'
	var offsets = [Vector2(0, map_size.size.height)]
	add_mirrors(body, offsets, name)


func _on_top_center_body_exit( body ):
	var obj_name = body.get_name()
	var name = 'top_center'
	remove_mirrors(obj_name, name)


func _on_top_right_body_enter( body ):
	var name = 'top_right'
	var offsets = [Vector2(-map_size.size.width, 0),
		Vector2(-map_size.size.width, -map_size.size.height),
		Vector2(0, -map_size.size.height)]
	add_mirrors(body, offsets, name)


func _on_top_right_body_exit( body ):
	var obj_name = body.get_name()
	var name = 'top_right'
	remove_mirrors(obj_name, name)


func _on_center_left_body_enter( body ):
	var name = 'center_left'
	var offsets = [Vector2(map_size.size.width, 0)]
	add_mirrors(body, offsets, name)


func _on_center_left_body_exit( body ):
	var obj_name = body.get_name()
	var name = 'center_left'
	remove_mirrors(obj_name, name)


func _on_center_right_body_enter( body ):
	var name = 'center_right'
	var offsets =[Vector2(-map_size.size.width, 0)]
	add_mirrors(body, offsets, name)


func _on_center_right_body_exit( body ):
	var obj_name = body.get_name()
	var name = 'center_right'
	remove_mirrors(obj_name, name)


func _on_bottom_left_body_enter( body ):
	var name = 'bottom_left'
	var offsets = [Vector2(map_size.size.width, 0),
		Vector2(map_size.size.width, -map_size.size.height),
		Vector2(0, -map_size.size.height)]
	add_mirrors(body, offsets, name)


func _on_bottom_left_body_exit( body ):
	var obj_name = body.get_name()
	var name = 'bottom_left'
	remove_mirrors(obj_name, name)


func _on_bottom_center_body_enter( body ):
	var name = 'bottom_center'
	var offsets = [Vector2(0, -map_size.size.height)]
	add_mirrors(body, offsets, name)


func _on_bottom_center_body_exit( body ):
	var obj_name = body.get_name()
	var name = 'bottom_center'
	remove_mirrors(obj_name, name)


func _on_bottom_right_body_enter( body ):
	var name = 'bottom_right'
	var offsets = [Vector2(0, -map_size.size.height),
		Vector2(-map_size.size.width, -map_size.size.height),
		Vector2(-map_size.size.width, 0)]
	add_mirrors(body, offsets, name)


func _on_bottom_right_body_exit( body ):
	var obj_name = body.get_name()
	var name = 'bottom_right'
	remove_mirrors(obj_name, name)
