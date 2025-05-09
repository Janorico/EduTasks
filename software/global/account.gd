class_name Account

var name := ""
var _filename = null
var scores: Dictionary[String, Dictionary] = {
	"MATH": {
		"ADD": TaskScore
	}
}


func _init(n: String, s: Dictionary[String, Dictionary] = {}, fn = null) -> void:
	name = n
	scores = s
	_filename = fn


func save() -> void:
	var json = {
		"account": {
			"name": name
		},
		"scores": {}
	}
	for cn in scores:
		var c: Dictionary = scores[cn]
		json["scores"][cn] = {}
		for sn in c:
			var s: TaskScore = c[sn]
			json["scores"][cn][sn] = {
				"correct": s.correct,
				"wrong": s.wrong
			}
	if not _filename:
		_filename = name.to_snake_case() + str(randi() % 100) + ".json"
	var f := FileAccess.open(AM.ACCOUNTS_DIR + "/" + _filename, FileAccess.WRITE)
	f.store_string(JSON.stringify(json))
	f.close()


static func load(p: String) -> Account:
	var f := FileAccess.open(p, FileAccess.READ)
	var json: Dictionary = JSON.parse_string(f.get_as_text())
	f.close()
	var scrs_out: Dictionary[String, Dictionary] = {}
	var scrs: Dictionary = json["scores"]
	for cn in scrs:
		var c: Dictionary = scrs[cn]
		scrs_out[cn] = {}
		for sn in c:
			var s: Dictionary = c[sn]
			scrs_out[cn][sn] = TaskScore.new(s["correct"], s["wrong"])
	return Account.new(json["account"]["name"], scrs_out, p.get_file())


class TaskScore:
	var correct := 0
	var wrong := 0
	
	func _init(c: int, w: int) -> void:
		correct = c
		wrong = w
