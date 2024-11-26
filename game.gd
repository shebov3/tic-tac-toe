extends Node2D
enum {BFS, DFS, IDS, UCS}
var modes = {"BFS":BFS,"DFS":DFS,"IDS":IDS,"UCS":UCS}
var mode = BFS

func _ready() ->void:
	for child in get_children():
		if child.is_class("Button"):
			child.button_down.connect(_mode.bind(child.name))

func _mode(Name):
	mode = modes[Name]
	
