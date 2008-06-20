#!/usr/bin/env ruby

require "rubygems"
require "hparser"
require "pp"

require 'hparser/block/pair'
require 'hparser/block/collectable'


class HParser::Block::RAW < HParser::Parser::Pair
	include HParser::Parser::Collectable

	def self.parse(scanner, inlines)
		if scanner.scan(/^></)
			content = scanner.matched
			until content.match(/><$/)
				content << "\n" << scanner.scan(/.*/)
			end
			self.new content[1..-2]
		end
	end

	def self.<=>(o)
		-2
	end

	def to_html
		@content
	end
end

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

* Agenda

+ Introducing to net-irc
+ About the DSL (or something DSL-ish)
+ Applications using net-irc

><!--
comment
--><

*
><div class="title-leaf"><
Introducing to net-irc
></div><

* What is net-irc?

- Is yet another IRC library
- Forked from RICE by akira yamada
- Has both Client and Server


* Changes from RICE

- Violate RFC for practical issue
- Don't use observer design pattern
- Wrote prettily


*
><div class="title-leaf"><
Applications using net-irc
></div><


* mini-blog IRC gateways

- Twitter (tig.rb)
- Wassr (wig.rb)
- Nowa (nig.rb)

* Lingr IRC gateways

* Citrus IRC BOT framework


