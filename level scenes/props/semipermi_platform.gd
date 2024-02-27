extends StaticBody2D
func fall():
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.set_deferred("disabled", false)
