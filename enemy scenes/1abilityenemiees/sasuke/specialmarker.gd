extends Marker2D

@export var bullet : PackedScene
var target = Vector2(0.0,0.0)
var follow = false

func _ready():
	$"..".SPEED = 25
var tempos 
var tempos2
func _process(_delta):
	if follow == true:
		targetmath()

func _physics_process(_delta):
	self.look_at(target)
	if $"..".dir < 0:
		$Sprite2D.flip_v = true
		$Sprite2D.position.x = 15
		$Sprite2D.position.y = -5
	elif $"..".dir > 0:
		$Sprite2D.flip_v = false
		$Sprite2D.position.x = 5
		$Sprite2D.position.y = 5

func targetmath():
	tempos = global_position.x - GameUtils.posX
	tempos2 = global_position.x - GameUtils.posXP2
	if tempos < 0:
		tempos = tempos * -1
	if tempos2 < 0:
		tempos2 = tempos2 * -1
	
	if tempos < tempos2:
		target = Vector2(GameUtils.posX,GameUtils.posY)
		if GameUtils.posX < global_position.x:
			$"..".dir = -1
		elif GameUtils.posX > global_position.x:
			$"..".dir = 1
	elif tempos > tempos2:
		target = Vector2(GameUtils.posXP2,GameUtils.posYP2)
		if GameUtils.posXP2 < global_position.x:
			$"..".dir = -1
		elif GameUtils.posXP2 > global_position.x:
			$"..".dir = 1

func _on_timer_timeout():
	var bull
	bull = bullet.instantiate()
	owner.add_sibling(bull)
	bull.transform = $".".global_transform

func _on_visible_on_screen_notifier_2d_screen_entered():
	$Timer.start()
	follow = true
func _on_visible_on_screen_notifier_2d_screen_exited():
	$Timer.stop()
	follow = false
