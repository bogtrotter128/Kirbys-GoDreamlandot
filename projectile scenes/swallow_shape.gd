extends Area2D


func _process(_delta):
	if GameUtils.Killsuck == true:
		self.queue_free()
		

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		GameUtils.HELDABILITY = body.copyAbilityScore
		GameUtils.mouthValue += 1
		print("MOUTH VALUE: ", GameUtils.mouthValue)
		print("EATEN SCORE: ", body.copyAbilityScore)
		print("GAINED SCORE: ", GameUtils.ABILITY)
		body.queue_free()
		GameUtils.Killsuck = true


func _on_pull_body_entered(body):
	if body.is_in_group("mobs"):
		body.sucked = true


func _on_pull_body_exited(body):
	if body.is_in_group("mobs"):
		body.sucked = false
