extends ColorRect

@onready var tasks_tree: Tree = $TaskSelection/TaskChooser/TasksContainer/Tasks
@onready var tv = $TaskView
@onready var anim_bg_mat: Material = material
var tasks: Dictionary[String, Dictionary] = {
	"MATH": {
		"ADD": Task.AddTask.new(),
		"SUBTRACT": Task.SubtractTask.new(),
		"MULTIPLY": Task.MultiplyTask.new(),
		"DIVIDE": Task.DivideTask.new()
	}
}

var account = null
var task = null
var score = null


func _ready() -> void:
	var ri = tasks_tree.create_item()
	ri.set_text(0, "TASKS") # Really unnecessary
	for c in tasks:
		if not account.scores.has(c):
			account.scores[c] = {}
		var ci = tasks_tree.create_item(ri)
		ci.set_selectable(0, false)
		ci.set_text(0, c)
		for t in tasks[c]:
			if not account.scores[c].has(t):
				account.scores[c][t] = Account.TaskScore.new(0, 0)
			var ti = tasks_tree.create_item(ci)
			ti.set_text(0, t)


func _on_task_selected() -> void:
	var ti = tasks_tree.get_selected()
	if not ti:
		return
	# Open task
	var t = create_tween()
	t.finished.connect(func() -> void:
		$TaskSelection.hide()
		material = null
	)
	t.set_parallel()
	t.tween_property(self, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	t.tween_property($TaskSelection, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	tv.show()
	tv.modulate = Color(1.0, 1.0, 1.0, 0.0)
	t.tween_property(tv, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	var cn = ti.get_parent().get_text(0)
	var tn = ti.get_text(0)
	task = tasks[cn][tn]
	score = account.scores[cn][tn]
	tv.create_task()


func _on_back_button_pressed() -> void:
	# Close task
	var t = create_tween()
	$TaskSelection.show()
	material = anim_bg_mat
	t.finished.connect(func() -> void:
		tv.hide()
		task = null
		score = null
	)
	t.set_parallel()
	t.tween_property(self, "color", Color(0.4, 0.4, 0.4, 1.0), 1.0)
	$TaskSelection.show()
	t.tween_property($TaskSelection, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	t.tween_property(tv, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
