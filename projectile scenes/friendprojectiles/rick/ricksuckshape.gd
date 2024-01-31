extends Area2D
var playerval
func _ready():
	if is_in_group("player1"):
		GameUtils.Killsuck = true
		GameUtils.Killsuck = false
		playerval = 1
	if is_in_group("player2"):
		GameUtils.KillsuckP2 = true
		GameUtils.KillsuckP2 = false
		playerval = 2

func _process(_delta):
	if GameUtils.Killsuck == true && playerval == 1:
		self.queue_free()
	if GameUtils.KillsuckP2 == true && playerval == 2:
		self.queue_free()

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
