extends Area2D
func _ready():
	$CollisionShape2D.call_deferred("set","disabled",true)

func _physics_process(_delta):
	if $"..".crouch == true:
		$CollisionShape2D.call_deferred("set","disabled",false)
	if $"..".crouch == false:
		$CollisionShape2D.call_deferred("set","disabled",true)

func _on_body_entered(body):
	if body.is_in_group("semipermiplatform"):
		body.fall()
		$CollisionShape2D.call_deferred("set","disabled",true)
