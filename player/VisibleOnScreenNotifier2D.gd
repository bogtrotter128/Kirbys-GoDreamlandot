extends VisibleOnScreenNotifier2D
var rcall = false
func _ready():
	set_process(false)
	await get_tree().create_timer(0.5).timeout
	set_process(true)

func _on_screen_exited():
	if GameUtils.CANRECALL == true:
		rcall = true
		if GameUtils.RECALL == false:
			GameUtils.RECALL = true
			recall()

func _on_screen_entered():
	rcall = false
 
func _process(_delta):
	if rcall == true && GameUtils.RECALL == false:
		GameUtils.RECALL = true
		rcall = false
		recall()

func recall():
	if $"..".is_in_group("player1"):
		GameUtils.firstplayerrecall = true
	if $"..".is_in_group("player2"):
		GameUtils.secondplayerrecall = true
	$"..".queue_free()
