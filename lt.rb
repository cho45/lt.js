#!/usr/bin/env ruby

require "rubygems"
require "hparser"
require "pp"

parsed   = HParser::Parser.new.parse(File.read(__FILE__)[/__END__\n([\s\S]+)/, 1])

sections = parsed.inject([[]]) do |r,element|
	element.instance_variable_set(:@level, element.level + 1) if element.kind_of?(HParser::Block::Head)
	if element.kind_of?(HParser::Block::Head) && element.level == 2
		r << [element]
	else
		r.last << element
	end
	r
end

require "erb"


ERB.new(<<'EOS', $SAFE, "<>").run(binding)
<% if ENV['REQUEST_METHOD'] %>
Content-Type: text/html

<% end %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>

		<link rel="stylesheet" type="text/css" href="lt.css" media="screen,tv"/>
		<meta name="robots" content="noindex,nofollow"/>

		<script type="text/javascript" src="lib/jquery-1.2.6.min.js"></script>
		<script type="text/javascript" src="lib/jquery.blockUI.js"></script>
		<script type="text/javascript" src="lib/keystring.js"></script>
		<script type="text/javascript" src="lib/lt.js"></script>
	</head>
	<body>
		<div id="whole">
			<h1 id="top"><a href="/"></a></h1>

			<div id="content">
			<% sections.each do |elements| next if elements.all? {|i| i.kind_of? HParser::Block::Empty } %>
				<div class="section">
					<%= elements.map {|i| i.to_html }.join("\n") %>
				</div>

			<% end %>
			</div>

			<div id="footer">
				<address>&copy; 2008 cho45@lowreal.net</address>
			</div>
		</div>
	</body>
</html>
EOS

__END__

* Pure DOM Constructor

- founder of laundrygirl
- <a href="http://washer-in-the-rye.com/">http://wassr-in-the-rye.com/</a>

*

><div class="title-leaf"><
puredomconstructor を precuredaisuki って空目する
></div><


* Pure DOM Constructor

ときどき jQuery より早い DOM 構築関数


* どういうときに早いか?

- 文字列から DOM を構築して、
- その DOM のいろんなところに触りたいとき

単純な innerHTML にはまず勝てないが総合力で勝負


* ユースケース

- JSON からエントリ HTML を生成するような場合


* テンプレート (てきとう)

>||
&lt;div class="message">
  &lt;div class="body">
    &lt;p class="description">来週も見てくださいね!&lt;/p>

    &lt;p class="messagefoot">
      by &lt;a class="name" href="/user/yunocchi">yuno&lt;/a>
      at &lt;a class="time">2008-07-25 (Fri) 02:00:38&lt;/a>
      via &lt;a href="/status/?via=web">web&lt;/a>
      &lt;a title="削除" href="/my/delete_status?status_rid=X365XX">del&lt;/a>
      &lt;a class="res">レス&lt;/a>
    &lt;/p>
    &lt;div class="replies">
    &lt;/div>
  &lt;/div>
&lt;/div>
||<

*

- みたいなのを JS で生成して
- 「レス」とか「削除」とかに JS 設定したい
- replies 以下にさらに要素足したい
- etc...

* jQuery だと

>||
var ret =
	$(template)
	.find("a.res")
		onclick(fun..)
	.end()
	.find("a.del")
		.onclick(fun..)
	.end()
	.find("replies");

for (var i = 0; i < replies.length; i++) {
	ret.append(...)
}
||<

* pdc だと

>||
var ret = dom(template, parent, data);
ret.res.onclick = fun...;
ret.del.onclick = fun...
for (var i = 0; i < replies.length; i++) {
	dom(template, ret.replies, replies[i]);
}
||<


*

- クラス名が設定された要素を保持しておいて返す
- #{foobar} を引数を使って展開する


* 

- jQuery の find/end は遅いのでその分はやくなる
- innerHTML は table 関係でハマりやすい


* まとめ

- そこそこ綺麗
- そこそこ早い
- を実現する

http://svn.coderepos.org/share/lang/javascript/pdc/trunk
