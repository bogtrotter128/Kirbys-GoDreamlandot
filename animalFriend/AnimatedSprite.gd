extends AnimatedSprite2D

var spritelist1 = [
	"res://animalFriend/spritesheets/rick/ricksprites.tres",
	"res://animalFriend/spritesheets/chuchu/chuchusprites.tres",
	"res://animalFriend/spritesheets/coo/coosprites.tres",
	"res://animalFriend/spritesheets/kine/kinesprites.tres",
	"res://animalFriend/spritesheets/nago/nagosprites.tres",
	"res://animalFriend/spritesheets/pitch/pitchsprites.tres"
] #need to replace animatedsprite with animation player orz
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
		if $"..".mouthFull == false && animation != str($"../globalvars".frenval) + "jump":
			$".".play(str($"../globalvars".frenval) +"jump")
		elif $"..".mouthFull == true && animation != str($"../globalvars".frenval) +"fat jump":
			$".".play(str($"../globalvars".frenval) +"fat jump")

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
				$".".play(str($"../globalvars".frenval) +"run")
			elif $"..".mouthFull == true:
				$".".play(str($"../globalvars".frenval) +"fat run")
		else:
			if $"..".crouch == false && $"..".inhaling == false && $"..".run == false && turn == false:
				if $"..".mouthFull == false:
					$".".play(str($"../globalvars".frenval) + "idle")
				elif $"..".mouthFull == true:
					$".".play(str($"../globalvars".frenval) +"fat idle")

	#run ani
	if $"..".run == true && $"..".crouch == false && $"..".falling == false:
		$".".set_speed_scale(1.5)
	elif $"..".run == false:
		$".".set_speed_scale(1.0)
		
	#spit ani
	if $"..".spit == true:
		$".".play(str($"../globalvars".frenval) +"open")

	#crouch ani
	if $"..".crouch == true && $".".animation != str($"../globalvars".frenval) +"crouch":
		$".".play(str($"../globalvars".frenval) +"crouch")

	#inhale ani
	if $"..".inhaling == true:
		$".".play(str($"../globalvars".frenval) +"open")

	if $"..".hurt == true && $"..".mouthFull == false:
		$".".play(str($"../globalvars".frenval) +"hurt")
	elif $"..".hurt == true && $"..".mouthFull == true:
		$".".play(str($"../globalvars".frenval) +"fat hurt")
var saveframe
var saveani
var turn = false
func turnframe():
	saveframe = $".".frame
	saveani = $".".animation
	$".".stop()
	turn = true
	if $"..".mouthFull == false:
		$".".play(str($"../globalvars".frenval) +"turn")
	if $"..".mouthFull == true:
		$".".play(str($"../globalvars".frenval) +"fat turn")
	await get_tree().create_timer(0.15).timeout
	$".".play(saveani)
	$".".frame = saveframe
	turn = false
	
