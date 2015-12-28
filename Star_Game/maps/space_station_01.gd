#need to fix
extends Area2D

#var name = 'terran_station'

func _ready():
	get_node("/root/globals").terran_base = self
	pass


