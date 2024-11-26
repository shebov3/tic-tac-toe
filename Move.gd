class_name Move extends Object

var row
var col
var player

func _init(r, c, p)->void:
	row = r
	col = c
	player = p

func _to_string() -> String:
	return str(row, col, player)
