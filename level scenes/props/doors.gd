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
	#12-1
	
}

func _ready():
	$AnimatedSprite2D.play(str(doorval))
	set_process_input(false)
	await get_tree().create_timer(1).timeout
	set_process_input(true)

var check1 = false
var check2 = false
func _input(_event):
	if Input.is_action_pressed("up") && check1 == true or Input.is_action_pressed("P2up") && check2 == true:
		if GameUtils.CANRECALL == true:
			GameUtils.CANRECALL = false
			Sfxhandler.play_sfx(doorsfx,self)
			transition()
			get_tree().paused = true

func transition():
	GameUtils.CANRECALL = false
	var dest = load(destinationlist[destination]).instantiate()
	dest.custompos = customposition
	main.get_parent().fade_to_black()
	await get_tree().create_timer(0.6).timeout
	main.get_parent().call_deferred("add_child",dest)
	get_tree().paused = false
	main.queue_free()

func _on_body_entered(body):
	if body.is_in_group("player1"):
		check1 = true
	if body.is_in_group("player2"):
		check2 = true
func _on_body_exited(body):
	if body.is_in_group("player1"):
		check1 = false
	if body.is_in_group("player2"):
		check2 = false
