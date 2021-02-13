extends Node2D

export (bool) var enabled = true


func _ready():
    if !enabled:
        queue_free()