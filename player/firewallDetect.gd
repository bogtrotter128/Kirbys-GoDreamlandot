extends Area2D

func _ready():
	firedectOff()

func firedectOn():
	$CollisionShape2D.call_deferred("set", "disabled", false)
	self.set_deferred("monitoring", true)
	self.set_deferred("monitorable", true)

func firedectOff():
	$CollisionShape2D.call_deferred("set", "disabled", true)
	self.set_deferred("monitoring", false)
	self.set_deferred("monitorable", false)

func _on_body_entered(body):
	if body.name == "maintiles":
		await get_tree().create_timer(0.3).timeout
		$"../..".squish = true
		$"../../projectileProducer".abilityStop()

func _process(_delta):
	$CollisionShape2D.position.x = $"../../projectileProducer".position.x * 1.625
