extends Area2D

var exit = false

func _on_body_entered(body):
	if body.name == "maintiles":
		exit = true
		print(body.name)

func _process(_delta):
	$collideDectShape.call_deferred("set", "disabled", true)
	await get_tree().create_timer(0.2).timeout
	$collideDectShape.call_deferred("set", "disabled", false)

func _physics_process(_delta):
	if exit == true:
		bodyEscape()

func bodyEscape():
	if $"..".activeAbility != 1:
		$"..".overrideX = true
		$"..".overrideY = true
		$"../smallhitbox".call_deferred("set", "disabled", true)
		$"../normalhitbox".call_deferred("set", "disabled", true)
		$collideDectShape.call_deferred("set", "disabled", true)
		$"..".velocity.y = -40
		await get_tree().create_timer(0.1).timeout
		exit = false
		$"..".overrideX = false
		$"..".overrideY = false
		$"../smallhitbox".call_deferred("set", "disabled", false)
		$"../normalhitbox".call_deferred("set", "disabled", false)
		$collideDectShape.call_deferred("set", "disabled", false)
