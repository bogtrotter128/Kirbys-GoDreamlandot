extends Control

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://selectScreen/popstar.tscn")

func _on_demo_world_pressed() -> void:
	GameUtils.roomloaded = "res://debug_world.tscn"
	get_tree().change_scene_to_file("res://main_world_scene.tscn")

func _on_demo_minigame_1_pressed() -> void:
	get_tree().change_scene_to_file("res://minigames/blockBall/block_ball.tscn")

func _on_fishin_pressed() -> void:
	get_tree().change_scene_to_file("res://minigames/fishin/fishing.tscn")
