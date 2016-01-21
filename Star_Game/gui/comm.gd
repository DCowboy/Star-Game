
extends Control

var small_chat
var large_chat
var message_input

func _ready():
	small_chat = get_node("small_panel/small_message_area")
	small_chat.set_scroll_follow(true)
	small_chat.set_scroll_active(true)
	large_chat = get_node("large_panel/large_message_area")
	large_chat.set_scroll_follow(true)
	large_chat.set_scroll_active(true)
	message_input = get_node("../../../comm_input")
	get_node("/root/globals").comm = self
	message('[color=#d8a520][b]Welcome to Star-Game[/b][/color]')


func message(text, time=-1):
	small_chat.newline()
	large_chat.newline()
	var prefix ="  "
#	if time >= 0:
#		prefix = "<"+format.time(time)+">  "
	small_chat.append_bbcode(prefix+text)
	large_chat.append_bbcode(prefix+text)


func _on_comm_input_text_entered( text ):
	pass # replace with function body


func _on_comm_input_focus_enter():
	pass # replace with function body


func _on_comm_input_focus_exit():
	pass # replace with function body
