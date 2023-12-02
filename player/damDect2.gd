extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage():
	$"..".hurt = true
	$"..".activeAbility = 0
	GameUtils.KillsuckP2 = true
	GameUtils.KillAbilityP2 = true
	GameUtils.IframeHitP2 = true

func _on_body_entered(body):
	pass # Replace with function body.
