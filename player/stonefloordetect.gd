extends Area2D


func _on_body_entered(body):
	if body.name == "maintiles" && $"../..".activeAbility == 4:
		await get_tree().create_timer(0.1).timeout
		$"../../projectileProducer".projectShoot(5)
		$"../../projectileProducer".projectShoot(6)
		await get_tree().create_timer(0.1).timeout
		$"../../projectileProducer".projectShoot(5)
		$"../../projectileProducer".projectShoot(6)
