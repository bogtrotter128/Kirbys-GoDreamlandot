extends Area2D
#
@export var WINDX = -2000.0 * GameUtils.DIR
#a good wind force is -300.0
@export var WINDY = 0.0

func _process(_delta):
	if GameUtils.Killsuck == true:
		self.queue_free()

func _on_body_entered(body):
	if body.is_in_group("mobs") or body.is_in_group("suckable"):
		GameUtils.HELDABILITY = body.copyAbilityScore
		GameUtils.mouthValue = 2
		print("MOUTH VALUE: ", GameUtils.mouthValue)
		print("EATEN SCORE: ", body.copyAbilityScore)
		print("GAINED SCORE: ", GameUtils.ABILITY)
		body.queue_free()
		GameUtils.Killsuck = true
#swallowshape should have a function to create a 2nd swallow shape that will
#check for when a 2nd enemy is swallowed. setting mouthValue = 3

func _on_pull_body_entered(body):
	if body.is_in_group("mobs") or body.is_in_group("suckable"):
		body.WINDFORCEX = WINDX


func _on_pull_body_exited(body):
	if body.is_in_group("mobs"):
		body.WINDFORCEX = 0.0
