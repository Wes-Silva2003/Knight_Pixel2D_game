extends Control

@onready var pop_click: AudioStreamPlayer = $pop_click
@onready var label_record: Label = $LabelRecord

func _ready() -> void:
	label_record.text = "Final Points: " + str(GameManager.points)
	
func _on_exit_pressed() -> void:
	pop_click.play()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
