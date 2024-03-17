extends Node2D

@export var blockval = 3

func  _ready():
	for i in get_child_count():
		get_child(i).blockval = blockval
