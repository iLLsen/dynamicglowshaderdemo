extends Sprite2D
var _time_passed
# Randomly update the glow intensity between 0.75 and 0.8
func _ready():
	randomize()
	_update_glow_intensity()
	# Update the glow intensity every 0.5 seconds
	set_process(true)
	_time_passed = 0.0

func _process(delta):
	_time_passed += delta
	if _time_passed >= 0.07:  # Update every 0.5 seconds
		_update_glow_intensity()
		_time_passed = 0.0

func _update_glow_intensity():
	var new_intensity = randf_range(0.85, 0.9)
	material.set("shader_parameter/glow_intensity", new_intensity)
