extends CharacterBody2D

var dir = 1
@export var SPEED = 80
@export var axisX = false
@export var axisY = false

func _physics_process(_delta):
	
	if axisX == true:
		velocity.x = SPEED * dir
	if axisY == true:
		velocity.y = SPEED * dir
	move_and_slide()


func _on_wall_detect_body_entered(body):
	if body.name == "maintiles":
		dir = dir * -1
