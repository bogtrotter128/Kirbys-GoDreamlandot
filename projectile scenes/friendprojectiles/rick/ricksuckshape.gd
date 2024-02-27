extends Area2D
var playerval
func _ready():
	if is_in_group("player1"):
		playerval = 1
	if is_in_group("player2"):
		playerval = 2

func _input(_event):
	if Input.is_action_just_released(get_parent().A):
		await get_tree().create_timer(0.3).timeout
		queue_free()

func _process(_delta):
	if get_parent().mouthFull == true:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs") or body.is_in_group("suckable"):
		if playerval == 2:
			GameUtils.HELDABILITYP2 = body.copyAbilityScore
			GameUtils.mouthValueP2 = 2
			GameUtils.KillsuckP2 = true
		if playerval == 1:
			GameUtils.HELDABILITY = body.copyAbilityScore
			GameUtils.mouthValue = 2
			GameUtils.Killsuck = true
		print("MOUTH VALUE: ", GameUtils.mouthValue)
		print("EATEN SCORE: ", body.copyAbilityScore)
		body.queue_free()
#swallowshape should have a function to create a 2nd swallow shape that will
#check for when a 2nd enemy is swallowed. setting mouthValue = 3
