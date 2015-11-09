
extends Sprite
var edges = {}
var objects

func _fixed_process(delta):
	
	pass
	
func make_images(edge, rect):
	var images = []
	pass
	

func make_edge(edge):
	var base_rect
	if get_type() == 'Sprite':
		base_rect = Rect2(Vector2(0, 0),\
		get_texture().get_size())
	elif get_type() == 'ReferenceFrame':
		base_rect = Rect2(Vector2(0, 0), get_size())
		
	var corner = Rect2(0, 0,\
	get_viewport_rect().size / 2)
	var vertical_middle = Rect2(0, 0,\
	base_rect.size.width - corner.size.width * 2,\
	corner.size.height)
	var horizontal_middle = Rect2(0, 0,\
	base_rect.size.height - corner.size.height * 2,\
	corner.size.width)
	var info = {}
	var this_rect = Rect2(0, 0, 0, 0)
	var mirrors
	
	if edge == 'top_left':
		this_rect.pos = base_rect.pos
		this_rect.size = corner.size
		var mirrors = make_images(edge, this_rect)
#	elif edge == 'top_center':
#		this_rect.pos = Vector2(\
#		base_rect.pos.x + corner.size.width, 
	pass

	
func set_edges():
	for edge in ['top_left', 'top_center', 'top_right',\
	'center_left', 'center_right', 'bottom_left', \
	'bottom_center', 'bottom_right']:
		edges[edge] = make_edge(edge)

func _ready():
	objects = get_tree().get_nodes_in_group('objects')
	set_edges()
	set_fixed_process(true)
	pass


