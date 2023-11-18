extends CharacterBody2D

@export var copyAbilityScore = 0
@export var SPEED = 70
@export var JUMP = -200
var WINDFORCEX = 0.0
var WINDFORCEY = 0.0
var update = false
var dir = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	dir = GameUtils.DIR * -1
	copyAbilityScore  = GameUtils.ABILITY

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += (gravity * 0.75) * delta
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
#adds wind blowing force
	velocity.x += WINDFORCEX * (delta * 5)
	velocity.y += WINDFORCEY * (delta * 2.5)
#this if statement makes sure kirby doesnt fall through Y wind
	if WINDFORCEY != 0 && velocity.y > 90:
		velocity.y = 50
	move_and_slide()

func _on_death_timer_timeout():
	$AnimatedSprite2D.play("dead")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()


func _on_wall_detect_body_entered(body):
	if body.name == "maintiles":
		dir = dir * -1
