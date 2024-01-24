extends Area2D

@export var doorval = 0
#put any scene in the unqiuely loaded door's packedscene var
@export var destination : PackedScene

func _ready():
	$AnimatedSprite2D.play(str(doorval))

var check1 = false
var check2 = false
func _process(_delta):
	if Input.is_action_just_pressed("up") && check1 == true or Input.is_action_just_pressed("P2up") && check2 == true:
		get_tree().change_scene_to_packed(destination)

func _on_body_entered(body):
	if body.name == "Player1":
		check1 = true
	if body.name == "Player2":
		check2 = true
func _on_body_exited(body):
	if body.name == "Player1":
		check1 = false
	if body.name == "Player2":
		check2 = false
