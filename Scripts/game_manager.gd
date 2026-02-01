extends Node

var lifes: int = 3
var points: int = 0
var record: int = 0

func _add_points(value):
	points += value

func _reset_points():
	points = 0

func _update_record():
	if record < points:
		record = points

func _reset_lifes():
	lifes = 3
