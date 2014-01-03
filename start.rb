require "./irc.rb"
require "./config.rb"

IRC.new(IRCBotConfig::NICK,nil,nil,IRCBotConfig::SERVER,IRCBotConfig::PORT)