extends Sprite2D
var _time_passed

func _ready():
	randomize()
	_update_glow_intensity()
	set_process(true)
	_time_passed = 0.0

func _process(delta):
	_time_passed += delta
	if _time_passed >= 0.07:  # Update every 0.07 seconds
		_update_glow_intensity()
		_time_passed = 0.0

func _update_glow_intensity():
	# Randomly update the glow intensity between 0.85 and 0.9
	var new_intensity = randf_range(0.85, 0.9)
	material.set("shader_parameter/glow_intensity", new_intensity)
