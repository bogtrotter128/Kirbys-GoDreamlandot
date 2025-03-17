extends Node2D
@onready var main = $".."
@export var Ypaddles = false
@export var stagescore = 00
@export var xbounds = [-84,84]
@export var ybounds = [-30,38]

func _ready():
	main.blockgoal = 0
	main.xbounds = xbounds
	main.ybounds = ybounds
	main.updatepaddles(Ypaddles)
	main.stagescore = stagescore
	await get_tree().create_timer(0.3).timeout
	main.fade_from_black()
