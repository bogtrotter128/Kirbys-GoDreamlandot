extends Node2D

var friend = preload("res://animalFriend/animalfriend.tscn")

func _ready():
	if GameUtils.FRENVAL > 0:
		summonfren($Player1,GameUtils.FRENVAL)
	if GameUtils.FRENVALP2 > 0:
		summonfren($Player2,GameUtils.FRENVALP2)

func summonfren(player,frenval): #only used by the players, not animal friends. is called by idlefriends
	var animalfriend = friend.instantiate()
	animalfriend.get_child(0).frenval = frenval
	if player.is_in_group("player1"):
		GameUtils.FRENVAL = frenval
		animalfriend.DIR = GameUtils.DIR
		animalfriend.add_to_group("player1")
	if player.is_in_group("player2"):
		GameUtils.FRENVALP2 = frenval
		animalfriend.DIR = GameUtils.DIRP2
		animalfriend.add_to_group("player2")
	animalfriend.position = Vector2(player.position.x,player.position.y - 2)
	player.call_deferred("add_sibling", animalfriend)
	#summon correct animal friend in their position
	player.queue_free() #delete player that interacted

var gooeyrecall = preload("res://projectile scenes/gooey_recall.tscn") 
func goorecall():
	GameUtils.secondplayerrecall = false
	var summongoo
	summongoo = gooeyrecall.instantiate()
	summongoo.position = Vector2(GameUtils.posXP2, GameUtils.posYP2)
	add_child(summongoo)
	await get_tree().create_timer(3).timeout
	GameUtils.RECALL = false

var kirbyrecall = preload("res://projectile scenes/kirby_recall.tscn")
func kirbcall():
	GameUtils.firstplayerrecall = false
	var summonkirb
	summonkirb = kirbyrecall.instantiate()
	summonkirb.position = Vector2(GameUtils.posX, GameUtils.posY)
	add_child(summonkirb)
	await get_tree().create_timer(3).timeout
	GameUtils.RECALL = false

func _process(_delta):
	if GameUtils.secondplayerrecall == true:
		goorecall()
	if GameUtils.firstplayerrecall == true:
		kirbcall()
