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

* net-irc

- cho45
- http://www.lowreal.net/
- from Subtech
- google 「ちんこ演算子の人」

love git.


* Agenda

+ Introducing to net-irc
+ Applications using net-irc
+ Citrus IRC BOT framework
+ About the DSL (or something DSL-ish)
+ DSL in the language

><!--
comment
--><


*
><div class="title-leaf"><
Introducing to net-irc
></div><

* My IRC status

- irssi user
- window number -> 54 (not channel num)


* What is net-irc?

- http://lowreal.rubyforge.org/net-irc/

- Is IRC library
- Forked from RICE by akira yamada
- Has both Client and Server


* Changes from RICE

- Violate RFC for practical issue
- Don't use observer design pattern
- Wrote prettily


* Violate RFC

- no restriction on nick length
-- RFC restrict nick length to 9 chars
- allow utf-8 nick
-- allow multibyte string
- (extendable MODE parser)
-- (working)

* Don't use observer

- Observer pattern
-- in the end, must write event dispatcher
- on_<var>event</var> is popular
- no more charms

* Wrote prettily

Write to server socket:

>||
post PRIVMSG, '#foo', 'msg'
post NOTICE,  '#foo', 'msg'
||<

All commands are defined as constant.

Use RFC as reference instead of net-irc reference.


* Sample Client

>||
class SimpleClient < Net::IRC::Client
  def on_privmsg(m)
    super
    post NOTICE, m[0], m[1] # echo
  end
end

SimpleClient.new("host", 6667, {
  :nick => "foobartest",
  :user => "foobartest",
  :real => "foobartest",
}).start
||<


* Sample Server

>||
class Sample < Net::IRC::Server::Session
  def on_privmsg(m)
    super
    post "foo!foo@host", NOTICE, m[0], m[1] # echo
  end
end

Net::IRC::Server.new(opts[:host], opts[:port], Sample, opts).start
||<

*
><div class="title-leaf"><
Applications using net-irc
></div><


* mini-blog IRC gateways

- Twitter (tig.rb) like TIG
- Wassr (wig.rb)
- Nowa (nig.rb) すいませんまだ使ってません

Suitable for practical use!

Distributed with net-irc. (examples/)

* Lingr IRC gateway

- Using Linger API

Suitable for practical use!

Distributed with net-irc. (examples/)

でもたまに切れる。

*...

examples なのはテスト書くのがめんどうだから……


* Citrus IRC BOT framework

>||
http://coderepos.org/share/wiki/Citrus
||<

- Has testing framework (using rspec)
- Supports gettext
- Has dynamic re-loading plugins

coderepos++

* Citrus

- Sample: chokan @freenode (registered)


* Citrus plugin

- Plugin tests are in same file!
- Use RSpec
- DummyCore class for test

- http://lab.lowreal.net/test/citrus/


* Citrus plugin

>||
class SimpleReply < Citrus::Plugin
  def on_privmsg(prefix, channel, message)
    # do...
  end
end

test do
  # run when test
  describe SimpleReply do
    before :all do
      @core   = DummyCore.new({})
      @socket = @core.socket

      @plugin = SimpleReply.new(@core, {
        "SimpleReply" => { config }
      })
    end

    it "should ..." do
    end
  end
end
||<


*
><div class="title-leaf"><
About the DSL
></div><

* It's DSL

>||
# client
post PRIVMSG, "#foo", "bar"

# server
post prefix, PRIVMSG, "#foo", "bar
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


* ...

>||
post PRIVMSG, "#foo", "bar"
||<

DSL...?

Maybe not.

*

Often, I try to make DSL.

But I assessed that DSL is irrelevance for this library..


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
- mechanize and hpricot is better


* DSL good examples

- Rake
- RSpec


* DSL good examples - Rake

>||
desc "Publish to RubyForge"
task :rubyforge => [:rdoc, :package] do
  require 'rubyforge'
  Rake::RubyForgePublisher.new(RUBYFORGE_PROJECT, 'fobar').upload
end
||<

Good example of hash arrow to represent dependency.


* DSL good examples - RSpec

>||
obj.should == "foo"
foo.should be_true
||<

Easy to read, easy to write.


* DSL good examples

- Rake
- RSpec

Can understand the purpose at first view!


* So, DSL requires...

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

Any sufficiently designed DSL is indistinguishable from NEW language.

高度に発達した DSL は新言語と見分けがつかない


*

Think before using DSL!


* End

Thank you
