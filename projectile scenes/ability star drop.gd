extends CharacterBody2D

@export var copyAbilityScore = 0
@export var SPEED = 70
@export var JUMP = -200
var update = false
var dir = 1

func _ready():
	if is_in_group("player1"):
		dir = GameUtils.DIR * -1
		Hud.updateability()
		copyAbilityScore  = GameUtils.ABILITY
		GameUtils.ABILITY = 0
	if is_in_group("player2"):
		dir = GameUtils.DIRP2 * -1
		Hud.updateability2()
		copyAbilityScore  = GameUtils.ABILITYP2
		GameUtils.ABILITYP2 = 0

func _physics_process(_delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, 200, 7)
		update = true
	elif is_on_floor():
		velocity.y = JUMP
		if update == true:
			if JUMP < 0:
				JUMP = JUMP + 20
			if SPEED > 0:
				SPEED = SPEED - 10
			update = false
	velocity.x = SPEED * dir
	move_and_slide()

func _on_death_timer_timeout():
	$AnimatedSprite2D.play("dead")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()


func _on_wall_detect_body_entered(body):
	if body.name == "maintiles":
		dir = dir * -1
