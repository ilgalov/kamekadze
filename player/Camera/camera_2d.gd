extends Camera2D

var shake_power := 0.0
var shake_until := 0.0
var shake_next := 0.0
var shake_offset := Vector2.ZERO

func _process(delta: float) -> void:
	if shake_until < Time.get_ticks_msec():
		offset = lerp(offset, Vector2.ZERO, delta) 
		return
	if shake_next < Time.get_ticks_msec():
		shake_offset = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized() * shake_power
		shake_next = Time.get_ticks_msec() + 50
	offset = lerp(offset, shake_offset, delta)
	
func shake(s, p = 100):
	shake_until = Time.get_ticks_msec() + s * 1000
	shake_power = p
