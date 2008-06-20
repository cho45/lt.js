function log (m) {
	if (window.console) console.log(m);
}

$.extend($.blockUI.defaults.overlayCSS, { backgroundColor: '#000' });
$.extend($.blockUI.defaults.pageMessageCSS, { width: "50%",  top: "25%", left: "25%", margin: "" });

var $presentation = {};


$(function () {
	var container = $("#content");
	var sections  = $("div.section", container);
	var c = {
		w : $(window).width(),
		h : $(window).height()
	};
	var d = {
		w : (c.h - 100) * 1.333333,
		h : c.h - 100
	};
	var page = -1;

	var fontSize = c.w / 30;
	if ($(document.body).css("font-size").match(/(\d+)px/)) {
		fontSize = d.w / (800 / Number(RegExp.$1));
	}

	$(document.body).css({
		"width"  : c.w,
		"height" : c.h
	});
	
	
	var information = $("<div id='Lt-information'/>").appendTo(document.body).css({
		"position"    : "absolute",
		//		"top"     : (c.h - d.h) / 2,
		//		"left"    : 0,
		"bottom"      : 0,
		"right"       : 0,
		"line-height" : "2",
		"font-size"   : fontSize * 0.5 + "px"
	});
	var pageInfo = $("<span class='page'/>").appendTo(information);

	container.css({
		"position" : "absolute",
		"top"      : (c.h - d.h) / 2,
		"width"    : "100%",
		"height"   : d.h
	});


	sections.each(function (i) {
		var e = $(this);
		e.addClass("slide");
		e.css({
			"width"     : d.w,
			"height"    : d.h,
			"top"       : 0,
			"left"      : (d.w + c.w) * 2,
			"z-index"   : i + 1,
			"font-size" : fontSize + "px"
		});
	});

	$("img", container).each(function () {
		var cw = this.parentNode.offsetWidth * 0.8;
		var w = $(this).width();
		var h = $(this).height();
		if (w > cw) {
			this.width = cw;
			this.height = h * (cw / w);
		}
	});

	$("a").each(function () {
		this.target = "_blank";
	});

	$("code.javascript.runnable").each(function () {
		$(this).click(function () {
			var t = "(function () { \n"+$(this).text()+"\n})();";
			eval(t);
		});
	});


	$(document).keypress(function (e) {
		switch (keyString(e)) {
			case "j": {
				next();
				break;
			}
			case "k": {
				prev();
				break;
			}
			case "i": {
				index();
			}
		}
	});

	setTimeout(function () {
		if (location.hash.match(/#(\d+)/)) {
			var page = Number(RegExp.$1);
			for (var i = 0; i < page; i++) next();
		} else {
			$.blockUI({ message: "<p>スライドを進めるには j、戻るには k を押してください</p>" });
			// next();
		}
	}, 100);

	function next () {
		$.unblockUI();
		page++;
		if (page > sections.length - 1) {
			page = sections.length - 1;
			return;
		}
		var prev = sections[page-1];
		$(sections[page]).animate({
			left : (c.w - d.w) / 2
		}, "slow", "linear", function () {
			if (prev) $(prev).hide();
		});
		info();
	}

	function prev () {
		page--;
		if (page < 0) {
			page = 0
			return;
		}
		$(sections[page]).show();
		$(sections[page+1]).animate({
			left : (d.w + c.w) * 2
		}, "slow");
		info();
	}

	function info () {
		pageInfo.html([
			page + 1, " / ", sections.length
		].join(""));
		location.hash = page + 1;
	}

	function jump(n) {
		var t = n - page;
		if (t > 0) {
			for (var i = 0; i < t; i++) next();
		} else {
			for (var i = 0; i < -t; i++) prev();
		}
	}

	function index () {
		var e = arguments.callee._element;
		if (!e) {
			e = $("<div id='Lt-pageindex'/>").appendTo(document.body).click($.unblockUI);
			sections.each(function (i) {
				var title = $("h2", this).text();
				e.append($([
					"<a href='javascript:void(0)'>",
					i + 1, " : ", title,
					"</a>"].join("")).click(function () { $.unblockUI(); jump(i) }));
			});
			arguments.callee._element = e;
		}
		$.blockUI(e, {
			"top": (c.h - d.h) / 2,
			"left": 0,
			"font-size": "80%",
			color: "#fff",
			height: d.h + "px",
			width: c.w + "px",
			overflow: "auto",
			border: "none",
			background: "transparent",
			"text-align": "left"
		})
	}

	$presentation.next = next;
	$presentation.prev = prev;
});
