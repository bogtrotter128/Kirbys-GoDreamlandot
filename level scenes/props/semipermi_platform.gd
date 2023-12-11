extends StaticBody2D
var cancheck = false

func _input(_event):
	if Input.is_action_just_pressed("down") && cancheck == true:
		await get_tree().create_timer(0.1).timeout
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(0.1).timeout
		$CollisionShape2D.set_deferred("disabled", false)
		cancheck = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		cancheck = true
