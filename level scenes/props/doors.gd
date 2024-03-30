extends Area2D
@onready var main = $"../.."
@export var doorval = 0
@export var destination = ""
@export var customposition = Vector2(0,0)
var doorsfx = preload("res://kirbySprites/sfx/enter-door.wav")
@onready var destinationlist = {
	#grassland
	"11" : "res://level scenes/1grassland/11.tscn",
	"11-1" : "res://level scenes/1grassland/11_sub_1.tscn"
	#11-2
	#12
	#12
	
}

func _ready():
	$AnimatedSprite2D.play(str(doorval))

var check1 = false
var check2 = false
func _input(_event):
	if Input.is_action_pressed("up") && check1 == true or Input.is_action_pressed("P2up") && check2 == true:
		get_tree().paused = true
		transition()

func transition():
	var dest = load(destinationlist[destination]).instantiate()
	Sfxhandler.play_sfx(doorsfx,main.get_parent())
	main.get_parent().fade_to_black()
	await get_tree().create_timer(0.6).timeout
	main.get_parent().call_deferred("add_child",dest)
	get_tree().paused = false
	main.queue_free()

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
