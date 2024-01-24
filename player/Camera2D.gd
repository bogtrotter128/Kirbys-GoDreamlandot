extends Camera2D

var xoffset = 0
func _process(_delta):
	#add in camera swapping functionality
	position.x = GameUtils.posX
	position.y = GameUtils.posY
	set_offset(Vector2(xoffset, 0))
	if GameUtils.SECONDPLAYER == true:
		offsetmath()
	
	#resets the pan back to 0 when player 2 is removed
	if GameUtils.SECONDPLAYER == false && self.get_offset() != Vector2(0,0):
		offsetzero()
	
	#this keeps the camera from panning past the hidden part of the screen
	if GameUtils.posX < get_limit(SIDE_LEFT) + 256:
		offsetzero()
	elif GameUtils.posX > get_limit(SIDE_RIGHT) - 256:
		offsetzero()

func offsetmath():
	var getdistX = ((GameUtils.posX - GameUtils.posXP2) / 7.0)
	if GameUtils.posX != GameUtils.posXP2 && GameUtils.posX > get_limit(SIDE_LEFT) + 256:
		xoffset = move_toward(self.get_offset().x,(-1 * getdistX), 0.5)
func offsetzero():
	xoffset = move_toward(self.get_offset().x,0, 0.5)
