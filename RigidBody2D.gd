extends CharacterBody2D
#ty CyberPotato for the tutorial
#https://www.youtube.com/@CyberPotatoDev
@onready var main = $".."
const VELOCITY_LIMIT = 13
var SPEED = 9
var damage = 1
var damtype = "normal" #"normal", "powered", "ability"
var powered = false
var lose = false

var speedup = 1.005
var last_collider_id
var start_pos: Vector2

@onready var sfx = {
	"die" : preload("res://kirbySprites/sfx/hurt.wav"),
	"stardrop" : preload("res://kirbySprites/sfx/star-hit.wav")
}

func _ready():
	start_pos = position

func _physics_process(delta):
	var collision = move_and_collide(velocity * SPEED * delta)
	if !(collision):
		return
	#YOU CAN GRAB THE COLLIDING OBJECT EHEHEHEEEE
	var collider = collision.get_collider()
	if collider.is_in_group("block"):
		collider.breakblock(damage,damtype)
	if collider.is_in_group("paddle"): #used for paddles and bumpers
		collider.catch()
	
	if collider.is_in_group("block") or collider.is_in_group("paddle"):
		ball_collision(collider)
	else:
		velocity = velocity.bounce(collision.get_normal())
	
	turnani()

func grabballpos():
	if $".".is_in_group("ball2"):
		main.ball2pos = position
	else:
		main.ball1pos = position

func ball_collision(collider):
	var ball_center_x = position.x
	var collider_width = collider.get_width()
	var collider_center_x = collider.position.x
	
	
	var velocity_xy = velocity.length()
	
	var collision_x = (ball_center_x - collider_center_x) / (collider_width / 2)
	
	var new_velocity = Vector2.ZERO
	
	new_velocity.x = velocity_xy * collision_x
	
	if collider.get_rid() == last_collider_id && collider.is_in_group("block"):
		new_velocity.x = new_velocity.rotated(deg_to_rad(randf_range(-45,45))).x * 9
	else:
		last_collider_id = collider.get_rid()
	
	#pythagarus theorm CRAZY 
	new_velocity.y = sqrt(abs(velocity_xy * velocity_xy - new_velocity.x * new_velocity.x)) * (-1 if velocity.y > 0 else 1)
	var speed_multiplier = speedup if collider.is_in_group("paddle") else 1.0
	
	velocity = (new_velocity * speed_multiplier).limit_length(VELOCITY_LIMIT)

func turnani():
	$AnimatedSprite2D.flip_v = true if velocity.y > 0 else false
	$AnimatedSprite2D.flip_h = true if velocity.x < 0 else false
func start_ball():
	position = start_pos
	randomize()
	velocity = Vector2(randf_range(-1,1),randf_range(-.1,-1)).normalized() * SPEED

func ability():
	pass

func powerup():
	powered = true
	damage = 3
	SPEED = 10
	damtype = "powered"
	$AnimatedSprite2D.play("power")
	$powertimer.start()
func _on_powertimer_timeout():
	if powered == true:
		powerdown()

func powerdown():
	if $AnimatedSprite2D.animation != "shrink":
		damage = 1
		await get_tree().create_timer(0.5).timeout
		$AnimatedSprite2D.play("shrink")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("default")
		SPEED = 9
		damtype = "normal"
		powered = false

func loseball():
	if lose == false:
		lose = true
		self.set_physics_process(false)
		$CollisionShape2D.call_deferred("set","disabled", true)
		$AnimatedSprite2D.play("lose")
		Sfxhandler.play_sfx(sfx["die"],main)
		await get_tree().create_timer(0.5).timeout
		main.lose()
		queue_free()

func _on_interaction_area_entered(area):
	if area == null:
		pass
	if area.is_in_group("collectable"):
		area.collect()
	if area.is_in_group("hazard"):
		if powered == false:
			loseball()
		else:
			powerdown()
