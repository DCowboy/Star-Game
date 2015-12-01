
extends ReferenceFrame


var map_size 
var mirrors = {}


func add_mirrors(object, offsets, edge_name):
	#creates illusion for world wrap by adding sprites in opposite sides of the map
	# 1 for sides and 3 for corners
	var copies = {}
	var images = []
	var parent = object
	for offset in offsets:
		var new_sprite = Sprite.new()
		new_sprite.set_texture(object.get_child(0).get_texture())
		if object.get_child(0).is_region() == true:
			new_sprite.set_region(true)
			new_sprite.set_region_rect(object.get_child(0).get_region_rect())
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
	#deletes illusion sprites if out of edge area
	for image in mirrors[name + edge].images:
		image.free()
	mirrors.erase(name + edge)

func update_mirrors():
	#moves illusion sprites while in edge area to correspond to partent sprite
	for mirror in mirrors:
		var pos = mirrors[mirror].parent.get_pos()
		var index = 0
		for image in mirrors[mirror].images:
			image.set_pos(pos + mirrors[mirror].offsets[index])
			index += 1


func check_bounds():
	#checks bounds for world wrap and moves accordingly
	for obj in mirrors:
		var pos = mirrors[obj].parent.get_pos()
		var new_pos = mirrors[obj].parent.get_pos()
		if pos.x <= -map_size.size.width / 2 + 10:
			new_pos.x = map_size.size.width / 2 - 10
		elif pos.x >= map_size.size.width / 2 - 10:
			new_pos.x = -map_size.size.width / 2 + 10
		if pos.y <= -map_size.size.height / 2 + 10:
			new_pos.y = map_size.size.height / 2 - 10
		elif pos.y >= map_size.size.height / 2 - 10:
			new_pos.y = -map_size.size.height / 2 + 10

		if pos != new_pos:
			mirrors[obj].parent.set_pos(new_pos)


func _fixed_process(delta):
	#checks for bullets
#	for each in range(get_child_count() - 1):
#		var check = get_child(each).get_overlapping_bodies()
#		for ping in check:
#			if not ping
	#checks to see if it should bother doing anything
	if mirrors.size() > 0:
		update_mirrors()
		check_bounds()
		

func _ready():
	map_size = get_item_rect()
	set_fixed_process(true)
	
#signal calls for objects who enter and leave edge areas
#------------------------------------------------------------
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
