@icon("res://addons/dragonforge_state_machine/assets/icons/state_machine_64x64.png")
## This node is intended to be generic and manage the various states in a game.
## If a SatteMachine has a state it should be added as a child node of the
## StateMachine.
class_name StateMachine extends Node


## The initial State for the StateMachine
@export var starting_state: State

# The current State of the StateMachine. Initially defaults to the first node it
# finds beneath itself if starting_state is not defined.
@onready var _current_state: State


## Sets up all the States for this StateMachine, and monitors any states being
## added or removed to the machine by being added or removed as children nodes
## of this StateMachine instance.
func _ready() -> void:
	for state in get_children():
		if state is State:
			state._activate_state()
	self.connect("child_entered_tree", _on_state_added)
	self.connect("child_exiting_tree", _on_state_removed)
	
	if starting_state:
		starting_state._enter_state()


## Switch to the target state from the current state. Fails if:[br]
## 1. The StateMachine does not have the passed state.[br]
## 2. The StateMachine is already in that state.[br]
## 3. The current State won't allow a transition to happen.[br]
## 4. The target State won't allow a transition to happen (e.g. cooldown timers).
func switch_state(state: State) -> void:
	if not _machine_has_state(state): return # The StateMachine does not have the passed state.
	if _current_state == state: return # The StateMachine is already in that state.
	if not state.can_transition: return # The target State won't allow a transition to happen (e.g. cooldown timers).
	
	if _current_state:
		if not _current_state.can_transition: return # The current State won't allow a transition to happen.
		_current_state._exit_state() # Run the exit code for the current state.
	
	_current_state = state # Assign the new state we are transitioning to as the current state.
	_current_state._enter_state() # Run the enter code for the new current state.


## Returns true if the passed state is the current state.
func is_current_state(state: State) -> bool:
	return _current_state == state


# Returns whether or not the StatMachine has this state.
# (A StateMachine has a state if the state is a child node of the StateMachine.)
func _machine_has_state(state: State) -> bool:
	for element in get_children():
		if element == state:
			return true
	return false


# Activates a state.
# (Called when a node enters the tree as a child node of this StateMachine.)
# Accepts all nodes as an argument because this is called whenever a child node
# enters the tree.
func _on_state_added(node: Node) -> void:
	if not node is State:
		return
	node._activate_state()


# Deactivates a state.
# (Called when a child node of this StateMachine leaves the tree.)
# Accepts all nodes as an argument because this is called whenever a child node
# exits the tree.
func _on_state_removed(node: Node) -> void:
	if not node is State:
		return
	node._deactivate_state()
