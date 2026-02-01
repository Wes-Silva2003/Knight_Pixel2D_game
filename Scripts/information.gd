extends Node

@onready var label_points: Label = $Control/LabelPoints
@onready var label_lifes: Label = $Control/LabelLifes
@onready var label_record: Label = $Control/LabelRecord

func _process(_delta):
	label_points.text = "Points: " + str(GameManager.points)
	label_record.text = "Record: " + str(GameManager.record)
	label_lifes.text = "Lifes: " + str(GameManager.lifes)
