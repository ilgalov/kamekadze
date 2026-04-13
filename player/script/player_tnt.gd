extends RigidBody2D

var speed_rot := 15
var jump_count = 0
var jump = false
var jump_combot = 0

var sp
var tween

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if (Input.is_action_just_pressed("ui_accept") or jump) and jump_count > 0:
		var xa = sign(global_position.x - $Marker_move.global_position.x)
		var yu = sign($Marker_move.global_position.y - global_position.y)
		var no_gravity = (linear_velocity.y / 2) if linear_velocity.y > 0 else 0.0
		jump_combot += 1
		if jump_combot > 3:
			$Boom.volume_db += abs(no_gravity) / 10
			$Boom.volume_db = clamp($Boom.volume_db, -7, 0)
		apply_impulse(Vector2(100 * xa, -600 * yu - no_gravity))
		$Boom.play()
		$Camera2D.shake(0.2)
		jump_count -= 1
		$Label.text = str(Vector2(100 * xa, -600 * yu - no_gravity)) + "\n" + str($Boom.volume_db)
	if Input.is_action_just_pressed("ui_accept") and jump_count <= 0 and !jump and $Timer_nohige.is_stopped():
		jump = true
		$Timer.start()
	var dir = Input.get_axis("ui_left", "ui_right")
	angular_velocity = speed_rot * dir
	if jump_count == 1 and $Timer_returndB.is_stopped():
		$Timer_returndB.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("floor") and jump_count < 1 and $Timer_nohige.is_stopped():
		jump_count += 1
		$Timer_nohige.start()
		if !$reloud.playing:
			$reloud.play()


func _on_timer_timeout() -> void:
	jump = false


func _on_colider_area_entered(_area: Area2D) -> void:
	call_deferred("reloud")

func reloud():
	global_position = Global.spawn
	rotation = 0


func _on_save_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	Global.spawn = body.global_position + Vector2(15, -50)
	appended()

func appended():
	sp = $YouSave.get_node("MarginContainer")
	tween = create_tween()
	tween.tween_property(sp, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)
	tween.tween_property(sp, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)


func _on_timer_returnd_b_timeout() -> void:
	if jump_count == 1:
		$Boom.volume_db = -7
		jump_combot = 0
