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

* Reject <- Inject

- cho45 / http://www.lowreal.net/

* Resh

- RDoc 用のテンプレート
- デフォルトのテンプレートはフレームついてて検索しにくい
- 割と頑張って RDoc に動的パッチ
- CPAN ちっくな配色

* Resh

http://coderepos.org/share/wiki/Resh

ぜひ使ってください!

* Resh

終了

* require "future"

お先まっくら……

未来の通しが欲しいです……


* require "future"

ノンノンノンノン


* require "future"

それはどうでもよくて


* require "future"

>||
gem install future
||<

僕も未来を gem でインストールしたい


* require "future"

- Future をちょっと実装してみたもの
- Future -> 未実行のものの代替オブジェクト
- see wikipedia

>||
# 即座にかえる f はまだ計算されていない
f = Kernel.async.sleep(2)

# 計算結果が即座に必要になればブロックする
p f
||<

* require "future"

デモ

* require "future"

何かかっこくないですか!

Fiber 版も実装して、制御できるようにもしたい


* require "ruby"

以上です。

RubyKaigi 本当にありがとうございました!



