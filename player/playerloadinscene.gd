extends Node2D

var friend = preload("res://animalFriend/animalfriend.tscn")
var dropfriend = preload("res://animalFriend/idlefriend.scn")

var friendlist = [
	"res://animalFriend/rick/Rickcode.tscn",
	"res://animalFriend/Chuchu/Chuchucode.tscn"
	
]
var friendspritelist = [
	"res://animalFriend/rick/ricksprite.tscn",
	"res://animalFriend/Chuchu/chuchusprite.tscn"
	
]

func _ready():
	if GameUtils.FRENVAL > 0:
		summonfren($Player1,GameUtils.FRENVAL)
	if GameUtils.FRENVALP2 > 0:
		summonfren($Player2,GameUtils.FRENVALP2)

func summonfren(player,frenval): #only used by the players, not animal friends. is called by idlefriends
	var animalfriend = friend.instantiate()
	var friendcode = load(friendlist[frenval -1]).instantiate()#YOU MUST INSTATIATE A RESOURCE
	var friendsprite = load(friendspritelist[frenval -1]).instantiate()# BEFORE CALLING IT AS A NODE
	if player.is_in_group("player1"):
		GameUtils.FRENVAL = frenval
		animalfriend.DIR = GameUtils.DIR
		animalfriend.add_to_group("player1")
	if player.is_in_group("player2"):
		GameUtils.FRENVALP2 = frenval
		animalfriend.DIR = GameUtils.DIRP2
		animalfriend.add_to_group("player2")
	animalfriend.add_child(friendcode) #adds the code node to the animalfriend
	animalfriend.add_child(friendsprite) #adds the sprite and code to the animal friend
	animalfriend.position = Vector2(player.position.x,player.position.y - 2)
	player.call_deferred("add_sibling", animalfriend)
	player.queue_free()
	#summon correct animal friend in their position

func dropanimalfriend(playerl,friendval,pos):
	var animalfrienddrop = dropfriend.instantiate()
	var player = playerl.instantiate()
	animalfrienddrop.frenval = friendval
	animalfrienddrop.position = pos
	call_deferred("add_child", animalfrienddrop)
	player.position = pos
	call_deferred("add_child", player) # why does this sometimes dupe the player??
	#AND SUMMON THE PLAYER BACK

var gooeyrecall = preload("res://projectile scenes/recallplayerobjects/gooey_recall.tscn") 
func goorecall():
	GameUtils.secondplayerrecall = false
	var summongoo
	summongoo = gooeyrecall.instantiate()
	summongoo.position = Vector2(GameUtils.posXP2, GameUtils.posYP2)
	add_child(summongoo)
	await get_tree().create_timer(3).timeout
	GameUtils.RECALL = false

var kirbyrecall = preload("res://projectile scenes/recallplayerobjects/kirby_recall.tscn")
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
