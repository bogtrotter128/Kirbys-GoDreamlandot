extends Marker2D
var group = ""
func _ready():
	if $"..".is_in_group("player1"):
		group = "player1"
	if $"..".is_in_group("player2"):
		group = "player2"

func projectShoot(item):
	var projectS
	projectS = item.instantiate()
	projectS.add_to_group(group)
	owner.add_sibling(projectS)
	projectS.transform = $".".global_transform

#summons hitboxes that follow the player
#missing the owner.add_child() and the $pp.global_transform
func projectFollow(item):
	var projectF
	projectF = item.instantiate()
	projectF.add_to_group(group)
	add_sibling(projectF)
	projectF.transform = $".".transform
