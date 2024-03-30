extends Node2D

var friend = preload("res://animalFriend/animalfriend.tscn")
var dropfriend = preload("res://animalFriend/idlefriend.scn")
@onready var pause = $"HUD/pause menu"
var paused = false

var kirbyrecall = preload("res://projectile scenes/recallplayerobjects/kirby_recall.tscn")
var gooeyrecall = preload("res://projectile scenes/recallplayerobjects/gooey_recall.tscn") 

var friendlist = [
	"res://animalFriend/rick/Rickcode.tscn",
	"res://animalFriend/Chuchu/Chuchucode.tscn",
	"res://animalFriend/coo/coocode.tscn",
	"res://animalFriend/kine/kinecode.tscn",
	"res://animalFriend/nago/nagocode.tscn",
	"res://animalFriend/pitch/pitchcode.tscn"
]
var friendspritelist = [
	"res://animalFriend/rick/ricksprite.tscn",
	"res://animalFriend/Chuchu/chuchusprite.tscn",
	"res://animalFriend/coo/coosprite.tscn",
	"res://animalFriend/kine/kinesprite.tscn",
	"res://animalFriend/nago/nagosprite.tscn",
	"res://animalFriend/pitch/pitchsprite.tscn"
]
var friendspritelist2 = [
	"res://animalFriend/rick/ricksprite2.tscn",
	"res://animalFriend/Chuchu/chuchusprite2.tscn",
	"res://animalFriend/coo/coosprite2.tscn",
	"res://animalFriend/kine/kinesprite2.tscn",
	"res://animalFriend/nago/nagosprite2.tscn",
	"res://animalFriend/pitch/pitchsprite2.tscn"
]

var uiInputs = ["1","2","3","4","5","6","7","8","9"]
var hashTable = {
	"1":1,
	"2":2,
	"3":3,
	"4":4,
	"5":5,
	"6":6,
	"7":7,
	"8":8,
	"9":9
}

func _process(_delta): # change this to just a direction method call of kirbcall/goocall
	if GameUtils.secondplayerrecall == true:
		goorecall()
	if GameUtils.firstplayerrecall == true:
		kirbrecall()

func _input(event):
	if Input.is_action_just_pressed("start"):
		pauseMenu()
	if GameUtils.opAbilities == true:
		opAbilityInput(event)

func summonfren(player,frenval,swimcheck): #only used by the players, not animal friends. is called by idlefriends
	var animalfriend = friend.instantiate()
	var friendcode = load(friendlist[frenval -1]).instantiate()#YOU MUST INSTATIATE A RESOURCE
	var friendsprite# BEFORE CALLING IT AS A NODE
	if player.is_in_group("player1"):
		GameUtils.FRENVAL = frenval
		animalfriend.DIR = GameUtils.DIR
		animalfriend.add_to_group("player1")
		friendsprite = load(friendspritelist[frenval -1]).instantiate()
	if player.is_in_group("player2"):
		GameUtils.FRENVALP2 = frenval
		animalfriend.DIR = GameUtils.DIRP2
		animalfriend.add_to_group("player2")
		friendsprite = load(friendspritelist2[frenval -1]).instantiate()
	print(swimcheck)
	animalfriend.swim = swimcheck
	print(animalfriend.swim)
	animalfriend.add_child(friendcode) #adds the code node to the animalfriend
	animalfriend.add_child(friendsprite) #adds the sprite and code to the animal friend
	animalfriend.position = Vector2(player.position.x,player.position.y - 2)
	player.call_deferred("add_sibling", animalfriend)
	player.queue_free()
	#summon correct animal friend in their position

func dropanimalfriend(playerl,friendval,pos,dir,swimcheck):
	var animalfrienddrop = dropfriend.instantiate()
	var player = playerl.instantiate()
	animalfrienddrop.frenval = friendval
	animalfrienddrop.position = pos
	animalfrienddrop.swim = swimcheck
	call_deferred("add_child", animalfrienddrop)
	player.position = pos
	player.swim = swimcheck
	if friendval == 4: #makes kine spit out kirby
		player.velocity.x += 200 * dir
	call_deferred("add_child", player)
	await get_tree().create_timer(0.2).timeout
	#AND SUMMON THE PLAYER BACK

func gooeyspawn(): #spawns gooey
	var summongoo
	summongoo = gooeyrecall.instantiate()
	summongoo.position = Vector2(GameUtils.posX - 15, GameUtils.posY - 25)
	add_child(summongoo)
	await get_tree().create_timer(3).timeout
	GameUtils.RECALL = false

#recall funcs
func goorecall():
	GameUtils.secondplayerrecall = false
	var summongoo
	summongoo = gooeyrecall.instantiate()
	summongoo.position = Vector2(GameUtils.posXP2, GameUtils.posYP2)
	add_child(summongoo)
	await get_tree().create_timer(3).timeout
	GameUtils.RECALL = false

func kirbrecall():
	GameUtils.firstplayerrecall = false
	var summonkirb
	summonkirb = kirbyrecall.instantiate()
	summonkirb.position = Vector2(GameUtils.posX, GameUtils.posY)
	add_child(summonkirb)
	await get_tree().create_timer(3).timeout
	GameUtils.RECALL = false

func pauseMenu():
	if paused:
		pause.set_process_input(false)
		pause.hide()
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = false
	else:
		pause.set_process_input(true)
		pause.show()
		get_tree().paused = true
	pause.selected = 1
	pause.movestart()
	paused = !paused

func opAbilityInput(event):
	if event.as_text() in uiInputs:
		GameUtils.ABILITY = hashTable[event.as_text()]
		GameUtils.ABILITYP2 = hashTable[event.as_text()]
		Hud.updateability()
		Hud.updateability2()
