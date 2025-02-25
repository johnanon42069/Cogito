extends AnimatableBody3D

signal object_state_updated(interaction_text : String)

@onready var audio_stream_player_3d = $AudioStreamPlayer3D

## Define the axis the object will rotate.
@export var rotation_axis : Vector3 = Vector3(1,0,0)
## Rotation speed.
@export var rotation_speed : float = 1
## Drag the nodes you want to get triggered in here from your scene hierarchy. Their interact func will be called when hold is complete.
@export var nodes_to_trigger : Array[Node]
## AudioStream to play while holding.
@export var hold_audio_stream : AudioStream

var interaction_nodes : Array[Node]

func _ready():
	self.add_to_group("interactable")
	interaction_nodes = find_children("","InteractionComponent",true) #Grabs all attached interaction components
	audio_stream_player_3d.stream = hold_audio_stream
	
	for node in interaction_nodes:
		if node and node.has_signal("is_being_held"):
			node.is_being_held.connect(_is_being_turned) 


func _is_being_turned(_time_remaining:float):
	self.rotate(rotation_axis,rotation_speed)
	

func interact(_player_interaction_component):
	audio_stream_player_3d.stop()
	
	for node in nodes_to_trigger:
		node.interact(null)
