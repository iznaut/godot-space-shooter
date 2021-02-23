extends Node2D

enum Difficulty {EASY, MEDIUM, HARD}
export (Difficulty) var difficulty_level


# todo filter formations by difficulty
# func _ready():
#     if !enabled:
#         queue_free()