extends Node2D

func _ready() -> void:
	$Control/cs.text = str(Global.previousScore)


func _on_main_menu_button_button_down() -> void:
	get_tree().change_scene_to_file("res://menuScenes/mainMenu.tscn")
	pass # Replace with function body.
