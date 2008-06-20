function keyString(e) {
	var specialCharTable1 = {
		9 : "TAB",
		27 : "ESC",
		33 : "PageUp",
		34 : "PageDown",
		35 : "End",
		36 : "Home",
		37 : "Left",
		38 : "Up",
		39 : "Right",
		40 : "Down",
		45 : "Insert",
		46 : "Delete",
		112 : "F1",
		113 : "F2",
		114 : "F3",
		115 : "F4",
		116 : "F5",
		117 : "F6",
		118 : "F7",
		119 : "F8",
		120 : "F9",
		121 : "F10",
		122 : "F11",
		123 : "F12"
	};
	var specialCharTable2 = {
		8 : "BS",
		13 : "RET",
		32 : "SPC"
	};

	var input = "";
	if (e.ctrlKey) input += "C-";
	if (e.altKey)  input += "M-";
	if (e.which == 0) {
		chr = specialCharTable1[e.keyCode];
	} else {
		chr = specialCharTable2[e.which];
		if (!chr) chr = String.fromCharCode(e.which);
	}
	input += chr;
	return input;
}
