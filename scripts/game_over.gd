extends Control

@onready var label_record: Label = $LabelRecord
@onready var pop_click: AudioStreamPlayer = $pop_click
@onready var load_btn: Button = $PanelContainer/VBoxContainer/load

#mostra a pontuação atual até o game over
func _ready() -> void:
	label_record.text = "Final Points: " + str(GameManager.points)
	load_btn.grab_focus()
	
#carrega o ultimo salvamento
func _on_load_pressed() -> void:
	pop_click.play()
	GameManager.load_game()
	
#volta para a tela menu inicial
func _on_exit_pressed() -> void:
	pop_click.play()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
