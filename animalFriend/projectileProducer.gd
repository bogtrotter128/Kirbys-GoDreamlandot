extends Marker2D
var group = ""
func _ready():
	if $"..".is_in_group("player1"):
		group = "player1"
	if $"..".is_in_group("player2"):
		group = "player2"
func _input(_event):
	if $"..".swim == true && $"..".overrideX == false && $"..".hasAbility == false && not $"..".is_on_floor():
		if $"..".frenval != 2 && $"..".frenval != 4:
			if Input.is_action_pressed($"..".UP) or Input.is_action_pressed($"..".JUMP):
				rotation_degrees = 270
			if Input.is_action_pressed($"..".DOWN):
				rotation_degrees = 90
		if Input.is_action_pressed($"..".LEFT):
			rotation_degrees = 180
		if Input.is_action_pressed($"..".RIGHT):
			rotation_degrees = 0
func _physics_process(_delta):
#this stops kirby from moving while an ability is active and on the floor
	if $"..".activeAbility > 0 && $"..".is_on_floor() or $"../animalfriendcode".bubblestart == false:
		$"..".overrideX = true
		$"..".canJump = false
		$"..".velocity.x = move_toward($"..".velocity.x, 0, 5)
		$"..".velocity.y = move_toward($"..".velocity.y, 0, 5)
	if $"..".DIR == 1 && $"..".swim == false or $"..".DIR == 1 && $"..".is_on_floor():
		rotation_degrees = 0
	if $"..".DIR == -1 && $"..".swim == false or $"..".DIR == -1 && $"..".is_on_floor():
		rotation_degrees = 180

func projectShoot(item):
	var projectS
	projectS = item.instantiate()
	projectS.add_to_group(group)
	owner.call_deferred("add_sibling", projectS)
	projectS.transform = $".".global_transform

#summons hitboxes that follow the player
#missing the owner.add_child() and the $pp.global_transform
func projectFollow(item):
	var projectF
	projectF = item.instantiate()
	projectF.add_to_group(group)
	call_deferred("add_sibling", projectF)
	projectF.transform = $".".transform
