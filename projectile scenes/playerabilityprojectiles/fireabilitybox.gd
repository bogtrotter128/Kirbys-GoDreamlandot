extends Area2D
var fireburstcheck = false
func _ready():
	get_parent().activeAbility = 1
	if get_parent().run == true && not Input.is_action_pressed(get_parent().UP) && not Input.is_action_pressed(get_parent().DOWN):
		fireburstcheck = true
		$"../AbilitySprites".runani = true
		get_parent().abilitycanstop = false
		get_parent().normaldamageguard = true
		fireburst()
	if get_parent().run == false && not Input.is_action_pressed(get_parent().UP) && not Input.is_action_pressed(get_parent().DOWN):
		$"../AbilitySprites".normani = true
		fireblow()
	if Input.is_action_pressed(get_parent().UP) && get_parent().run == false or Input.is_action_pressed(get_parent().DOWN) && get_parent().run == false:
		get_parent().normaldamageguard = true
		$"../AbilitySprites".upani = true
		fireup()
	
func _input(_event):
	if Input.is_action_just_released(get_parent().A) && fireburstcheck == false:
		await get_tree().create_timer(0.1).timeout
		stop()

func _physics_process(_delta):
	if get_parent().is_on_wall() && fireburstcheck == true:
		stop()

func fireburst():
	fireburstcheck = true
	get_parent().overrideY = true
	get_parent().overrideX = true
	#maybe iframes true?
	get_parent().velocity = Vector2((200 * get_parent().DIR),0)
	await get_tree().create_timer(0.5).timeout
	get_parent().abilitycanstop = true
	get_parent().run = false
	stop()

func fireblow():
	position.y = 3
	position.x = 20 * get_parent().DIR

func fireup():
	get_parent().velocity.y = 100
	position = Vector2(0,-5)
	$Area2D/CollisionShape2D.call_deferred("set","disabled",false)
	$CollisionShape2D.call_deferred("set","disabled",true)

func stop():
	get_parent().normaldamageguard = false
	get_parent().activeAbility = 0
	get_parent().overrideY = false
	get_parent().overrideX = false
	queue_free()

func _on_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		body.damage(3)
	if body.is_in_group("powblock"):
		body.blockbreak()
		await get_tree().create_timer(0.05).timeout
		stop()

func _on_area_2d_body_entered(body):
	if body == null:
		pass
	if body.is_in_group("mobs"):
		body.damage(3)
	if body.is_in_group("powblock"):
		body.blockbreak()
