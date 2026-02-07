extends Control

@onready var pop_click: AudioStreamPlayer = $pop_click
@onready var label_record: Label = $LabelRecord
@onready var exit: Button = $PanelContainer/VBoxContainer/exit

func _ready() -> void:
	label_record.text = "Final Points: " + str(GameManager.points)
	
func _on_exit_pressed() -> void:
	pop_click.play()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	exit.grab_focus()
