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

* Agenda

+ Introducing to net-irc
+ About the DSL (or something DSL-ish)
+ DSL in the language
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

* Sample Client

* Sample Server

*
><div class="title-leaf"><
About the DSL
></div><

* It's DSL

>||
# client
post PRIVMSG, "#foo", "bar"

# server
post nil, PRIVMSG, "#foo", "bar
||<


* Effective utilzation of Constant

>||
PRIVMSG     = 'PRIVMSG'
NOTICE      = 'NOTICE'
...
RPL_WELCOME = '001'
||<

I don't want to use String.

- It mades typo.
- It is not pretty.

*
><div class="title-leaf"><
DSL in the language
></div><

* DSL bad example

- scrAPI

>||
ebay_auction = Scraper.define do
  process "h3.ens>a",             :description=>:text, :url=>"@href"
  process "td.ebcPr>span",        :price=>:text
  process "div.ebPicture>a>img",  :image=>"@src"
  result :description, :url, :price, :image
end
||<

Can't understand the purpose at first view.

* DSL bad example - scrAPI

- what is second argument of process
- need to look the reference
- lerning cost > convenience


* DSL requires...

- Readable!
-- not requires precedent
- Writable!
-- not relying on reference

* DSL's problems

- hard to trace process
- hard to know Class defining the method
- IT IS A LANGUAGE.
-- It is difficult to design a language.

*

Good DSL is not aware that it is DSL.


*

Any sufficiently designed DSL is indistinguishable from host language.

高度に発達した DSL はホスト言語と見分けがつかない


*
><div class="title-leaf"><
Applications using net-irc
></div><


* mini-blog IRC gateways

- Twitter (tig.rb) like TIG
- Wassr (wig.rb)
- Nowa (nig.rb)

Suitable for practical use!

Distributed with net-irc. (examples/)

* Lingr IRC gateway

- Using Linger API

Suitable for practical use!

Distributed with net-irc. (examples/)


* Citrus IRC BOT framework

>||
http://coderepos.org/share/wiki/Citrus
||<

- Has testing framework (using rspec)
- Supports gettext
- Has dynamic re-loading plugins

