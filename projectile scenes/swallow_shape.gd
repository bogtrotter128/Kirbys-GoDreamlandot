extends Area2D
#
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

var target
var canpull = false
func _process(_delta):
	if GameUtils.Killsuck == true && playerval == 1:
		self.queue_free()
	if GameUtils.KillsuckP2 == true && playerval == 2:
		self.queue_free()

func _physics_process(_delta):
	if canpull == true:
		pull()

func _on_body_entered(body):
	if body.is_in_group("mobs") or body.is_in_group("suckable"):
		target = null
		canpull = false
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

func _on_pull_body_entered(body):
	if body.is_in_group("mobs") or body.is_in_group("suckable"):
		$pull/pullcollshape.call_deferred("set","disabled",true)
		print(body)
		target = body
		canpull = true

func pull():
	if target.is_in_group("powblock"):
			target.disablecollision()
	target.global_position.x = move_toward(target.global_position.x, get_parent().global_position.x, 1.5)
	target.global_position.y = move_toward(target.global_position.y, get_parent().global_position.y, 1.5)
