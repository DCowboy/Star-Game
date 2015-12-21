
extends Node
const entity_name = 0
const entity_drop_rate = 1
const entity_rarity = 2
const drop_name = 0
const drop_rate = 1
var entities = {}
var items = {}
var temp = [0]
var stats = [6]

func _ready():
	# Initialization here
	pass


func reward (victim, pieces=0):
#	for culprit in victim.credit:
#		if culprit == 'Player':
#			print('recieved reward of ' + str(victim.credit[culprit].gets))
	if pieces == 0:
		drop(victim)

func drop(obj):
	var globals = get_node("/root/globals")
	var number = 0
	if obj.type == 'asteroid':
		randomize()
		number = ceil(rand_range(0, obj.size + 1))
	if number > 0:
		for each in range(number):
			var chance = floor(rand_range(0, 101))
			var item = null
			if obj.material == 0:
				if chance > 75:
					item = globals.items.ship_repair.instance()
				elif chance > 50:
					item = globals.items.energy_restore.instance()
			elif obj.material == 1:
				if chance > 75:
					item = globals.items.energy_restore.instance()
				elif chance > 50:
					item = globals.items.ship_repair.instance()
			elif obj.material == 2:
				if chance > 90:
					item = globals.items.ship_repair.instance()
				elif chance > 80:
					item = globals.items.energy_restore.instance()
			if item != null:
				randomize()
				var item_pos = obj.get_pos()
				var child = item.get_node('Sprite') 
				item_pos.x += int(rand_range(-1, 1) * (child.get_texture().get_width() * child.get_transform().get_scale().x))
				item_pos.y += int(rand_range(-1, 1) * (child.get_texture().get_height() * child.get_transform().get_scale().y))
				item.set_pos(item_pos)
				get_node("/root/globals").current_map.add_child(item)
			else:
				
				pass
				
	pass