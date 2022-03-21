class_name State
extends Node

signal finished(next_state_name)

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	return


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	return


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	return


## Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
#func enter(_msg := {}) -> void:
#	pass
func enter():
	return

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	return


func _on_animation_finished(anim_name):
	return
