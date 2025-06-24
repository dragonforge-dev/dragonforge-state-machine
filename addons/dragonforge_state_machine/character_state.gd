## State for a Character (Player/NPC/Enemy
class_name CharacterStateMachine extends State

## The Character this CharacterState operates on.
var character: Node


# Assigns a value to character once the state has been activated.
func _activate_state() -> void:
	super()
	character = _state_machine.subject
