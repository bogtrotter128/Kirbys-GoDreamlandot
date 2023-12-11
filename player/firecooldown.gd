extends Timer

func _on_timeout():
	if $"../../projectileProducer".firescore < 31 && $"../..".activeAbility != 1:
		$"../../projectileProducer".firescore += 1
	
	if $"../../projectileProducer".firescore >= 30:
		$".".stop()
