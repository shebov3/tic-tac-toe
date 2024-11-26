extends Area2D

@onready var sprite2D: Sprite2D = $Sprite2D
var X = load("res://X.png")
var CanPlay = false
var Played = false
enum {BFS, DFS, IDS, UCS}
var Modes = {BFS:"BFS",DFS:"DFS",IDS:"IDS",UCS:"UCS"}

func _mouse_enter() -> void:
	if Played: return
	sprite2D.texture = X
	sprite2D.modulate.a = 0.5
	CanPlay = true

func _mouse_exit() -> void:
	if Played: return
	CanPlay = false
	sprite2D.modulate.a = 0

func _process(delta):
	if Played or not CanPlay: return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Played = true
		sprite2D.modulate.a = 1
		var row = int(self.name.substr(0,1))
		var col = int(self.name.substr(1,2))
		var parent = get_parent()
		parent.Board[row][col] = "X"
		parent.call(Modes[owner.mode])
