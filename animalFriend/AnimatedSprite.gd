extends AnimatedSprite2D

var spritelist1 = [
	"res://animalFriend/spritesheets/ricksprites.tres",
	"res://animalFriend/spritesheets/chuchusprites.tres",
	"res://animalFriend/spritesheets/coosprites.tres",
	"res://animalFriend/spritesheets/kinesprites.tres",
	"res://animalFriend/spritesheets/nagosprites.tres",
	"res://animalFriend/spritesheets/pitchsprites.tres"
]
var spritelist2 = [
	
	
]

func _ready():
	if $"..".is_in_group("player1"):
		sprite_frames = load(spritelist1[$"../globalvars".frenval -1])
	if $"..".is_in_group("player2"):
		sprite_frames = load(spritelist2[$"../globalvars".frenval -1])

func _process(_delta):
	if $"..".activeAbility != 0:
		$".".visible=false
	else:
		$".".visible=true
	
#jump ani
	if $"..".is_jumping == true && $"..".flight == false && $"..".inhaling == false && turn == false: 
		if $"..".mouthFull == false && animation != "jump":
			$".".play("jump")
		elif $"..".mouthFull == true && animation != "fat jump":
			$".".play("fat jump")

#flight ani
#	if $"..".flight == true:
#		if $".".animation != "flap":
#				$".".play("flight")
#		if Input.is_action_just_pressed("jump"):
#			$".".play("flap")
#			await $".".animation_finished
#			$".".play("flight")
	
#directional animation parameters
	if $"..".DIR == -1 && $"..".inhaling == false && $"../AbilitySprites".flip_h == false:
		$".".flip_h = true
		turnframe()
		$"../AbilitySprites".flip_h = true
	if $"..".DIR == 1 && $"..".inhaling == false && $"../AbilitySprites".flip_h == true:
		$".".flip_h = false
		turnframe()
		$"../AbilitySprites".flip_h = false
	
	var direction = Input.get_axis("left", "right")
	#determines if walking or idling
	if $"..".falling == false && $"..".inhaling == false && $"..".overrideX == false && turn == false:
		if direction:
			if $"..".mouthFull == false:
				$".".play("run")
			elif $"..".mouthFull == true:
				$".".play("fat run")
		else:
			if $"..".crouch == false && $"..".inhaling == false && $"..".run == false && turn == false:
				if $"..".mouthFull == false:
					$".".play("idle")
				elif $"..".mouthFull == true:
					$".".play("fat idle")

	#run ani
	if $"..".run == true && $"..".crouch == false && $"..".falling == false:
		$".".set_speed_scale(1.5)
	elif $"..".run == false:
		$".".set_speed_scale(1.0)
		
	#spit ani
	if $"..".spit == true:
		$".".play("open")

	#crouch ani
	if $"..".crouch == true && $".".animation != "crouch":
		$".".play("crouch")

	#inhale ani
	if $"..".inhaling == true:
		$".".play("open")

	if $"..".hurt == true && $"..".mouthFull == false:
		$".".play("hurt")
	elif $"..".hurt == true && $"..".mouthFull == true:
		$".".play("fat hurt")
var saveframe
var saveani
var turn = false
func turnframe():
	saveframe = $".".frame
	saveani = $".".animation
	$".".stop()
	turn = true
	if $"..".mouthFull == false:
		$".".play("turn")
	if $"..".mouthFull == true:
		$".".play("fat turn")
	await get_tree().create_timer(0.15).timeout
	$".".play(saveani)
	$".".frame = saveframe
	turn = false
	
