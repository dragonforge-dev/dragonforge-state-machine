[![Static Badge](https://img.shields.io/badge/Godot%20Engine-4.4.1.stable-blue?style=plastic&logo=godotengine)](https://godotengine.org/)

# Dragonforge State Machine
A base state machine class to be used in games.
# Version 0.2
For use with **Godot 4.4.1-stable** and later.
# Installation Instructions
1. Copy the **dragonforge_state_machine** folder from the **addons** folder into your project's **addons** folder.
2. In your project go to **Project -> Reload Current Project**
3. Wait for the project to reload.

# Usage
To use the **StateMachine** and **State** classes, you add a **StateMachine** to the **Node** you want it to control. Then you add a **State** node to the **StateMachine** for each state that you want the object to have.

## State Machine
1. Add a new node as you would normally. (The **Create New Node** window will appear.)
2. Type `state` into the Search box.
3. Select **StateMachine**.
4. Click the **Create** button.

## State
1. Add a new node as you would normally. (The **Create New Node** window will appear.)
2. Type `state` into the Search box.
3. Select **State**.
4. Click the **Create** button.

## CharacterState
1. Add a new node as you would normally. (The **Create New Node** window will appear.)
2. Type `state` into the Search box.
3. Select **CharacterState**.
4. Click the **Create** button.

This state differs from **State** in that it adds a `character` member which is the `subject` (parent) of the **StateMachine**.