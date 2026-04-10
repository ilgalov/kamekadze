extends RigidBody2D

var speed_rot := 15
var jump_count = 0
var jump = false

func _ready() -> void:
	global_position = Global.spawn

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if (Input.is_action_just_pressed("ui_accept") or jump) and jump_count > 0:
		var xa = sign(global_position.x - $Marker_move.global_position.x)
		var yu = sign($Marker_move.global_position.y - global_position.y)
		apply_impulse(Vector2(100 * xa, -600 * yu))
		$Boom.play()
		$Camera2D.shake(0.2)
		jump_count -= 1
	if Input.is_action_just_pressed("ui_accept") and jump_count <= 0 and !jump and $Timer_nohige.is_stopped():
		jump = true
		$Timer.start()
	var dir = Input.get_axis("ui_left", "ui_right")
	angular_velocity = speed_rot * dir


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
	get_tree().reload_current_scene()
