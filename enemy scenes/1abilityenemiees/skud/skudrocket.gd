extends Area2D

var dir = 0
var cantarget = false
@export var copyAbilityScore = 9
@export var splode : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.rotation_degrees = 0
	await get_tree().create_timer(0.5).timeout
	cantarget = true

var target = Vector2(0.0,0.0)
func _physics_process(delta):
	$"../Marker2D".look_at(target)
	if cantarget == false:
		$"..".position -= transform.y * 60 * delta
	if cantarget == true: #waits a little bit and then the rocket is allowed to target
		$"..".position += transform.x * 60 * delta
	$".".rotation_degrees = move_toward($".".rotation_degrees,$"../Marker2D".rotation_degrees,3)

func _process(_delta):
	targetmath()
	$"../Marker2D".global_position = $"..".global_position
	if cantarget == true && $AnimatedSprite2D.rotation_degrees != 90:
		rotatesprite()

var tempos
var tempos2
func targetmath():
	tempos = global_position.x - GameUtils.posX
	tempos2 = global_position.x - GameUtils.posXP2
	if tempos < 0:
		tempos *= -1
	if tempos2 < 0:
		tempos2 *= -1
	if tempos < tempos2:
		target = Vector2(GameUtils.posX ,GameUtils.posY)
	elif tempos > tempos2:
		target = Vector2(GameUtils.posXP2,GameUtils.posYP2)

func rotatesprite():
	$AnimatedSprite2D.rotation_degrees = move_toward($AnimatedSprite2D.rotation_degrees, 90, 3)

func _on_body_entered(body):
	if body.is_in_group("player") or body.name == "maintiles" or body.is_in_group("projectiles"):
		explode()
func explode():
	var explod = splode.instantiate()
	$"..".call_deferred("add_sibling",explod)
	explod.transform = $"..".global_transform
	$"..".queue_free()
