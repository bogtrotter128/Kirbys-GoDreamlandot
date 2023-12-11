extends Timer

func _on_timeout():
	$"../HPbar2".canupdate = true
	$"../HPbar".canupdate = true
	$"../Starbar".canupdate = true
