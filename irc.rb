#!/usr/bin/ruby
#coding: UTF-8

# IRC Class
# Author :: Alex Carvalho

require "socket"
require "logger"
require "./dice.rb"
require "./config.rb"

class IRC
    
    @@clients
    
    COMMAND_PREFIX = ""
    RESPONSE_LENGTH = 512 - 128 # IRC message length limit minus arbitrary length for header and command info
    RESPONSE_SUFFIX = "..."
    RESPONSE_BREAK_CHARS = /[\}\]\)\|\;\:\"]|[\.\,\!\?\']+\s|\s{2,}/
    RESPONSE_MAX_PARTS = 2     
    
    # IRC_MESSAGE_REGEX = /^(?: *:(?<source>[\w\-\|\[\]\{\}`^]*?(?:![\w\-\~]+)?(?:@)?(?:\w[\w\.\-]+[\.][\w\.\-]+\w)?)|) *(?<command>[a-zA-Z0-9]*) +(?<parameters>[^:]*)(?::(?<message>.*))?$/u
    IRC_MESSAGE_REGEX = /^(?: *:(?<source>(?:(?<nick>[\w\-\|\[\]\{\}`^]+)(?:!(?<id>[\w\-\~]+))?@)?(?<host>\w[\w\.\-]+[\.][\w\.\-]+\w)?)|) *(?<command>[a-zA-Z0-9]*) +(?<parameters>[^:\n]*)(?::(?<message>.*))?$/u # It's going to kill us! RUN!!!
    IRC_CHANNEL_REGEX = /[&#+!]+\S+/i
    
    CALL_REGEX = /\s*[\:\,\;]\s*/
    
    NET_MESSAGES = {
        :message => [ /PRIVMSG/i ],
        :notice => [ /NOTICE/i ],
        :authentication_request => [ /NOTICE/i, /Auth/i ],
        :ping => [ /PING/i ],
    }
    NET_COMMANDS = {
        :nick => ["NICK"],
        :user => ["USER"],
        :message => ["PRIVMSG"],   
        :notice => ["NOTICE"],
        :pong => ["PONG"],
        :authentication => ["NICKSERV", "IDENTIFY"],
        :join => ["JOIN"],
        :part => ["PART"],
        :quit => ["QUIT"],
    }
    
    CTCP_DELIMITER = [0x01].pack('U*')
    
    CTCP_COMMANDS = {
        :action => "ACTION"    
    }
    
    @nick
    @altnick
    @account
    @password
    @name
    
    @nick_regex
    @call_regex
    
    @server
    @port
    @server_password
    
    @id    
    @connection
    @connected = false
    @authenticated = false
    @log
    @rawlog
    
    @testing = false
    @timer
    @retry
    
    @users = {:admin => [], :vip => [], :non_grata => [], :banned => []}
    @channels = {}
    @queue
    @identities = {}
    
    @dicebot
    
    
    def initialize(nick = "BondsBot", account = nil, password = nil, server = "localhost", port = 6667, server_password = nil)
        
                        
        @connection = connect(server, port, server_password)
        
        # File.new("#{@nick}_input.txt", "w")
        
        # TCPSocket.new(@server, @port)        
        
        @rawlog = Logger.new("rawlogs/#{nick}@#{server}_raw.log", "daily")
        @rawlog.level = Logger::INFO
        
        @dicebot = Dice.new
        
        # puts NET_MESSAGES[:authentication_request]
        
        while (line = @connection.gets)
            
            if line
                
                line = line.chomp
                puts inrecord = "<< #{line}"
                @rawlog.info(inrecord)
                parse = line.match(IRC_MESSAGE_REGEX)
                
                if parse
                    if !@authenticated
                        @authenticated = authenticate(nick, account, password)
                        @server = parse[:source].strip                        
                    else
                        
                        
                        case parse[:command].strip
                        when NET_MESSAGES[:ping][0]
                            send_command(nil,NET_COMMANDS[:pong][0],parse[:message].strip)
                        when NET_MESSAGES[:message][0]
                            case parse[:parameters].strip
                            when @nick_regex
                                reply_message(parse[:message].strip,parse[:nick].strip,nil,true)
                            when IRC_CHANNEL_REGEX
                                reply_message(parse[:message].strip,parse[:nick].strip,parse[:parameters].strip)
                            end
                        when "396"
                            send_command(nil, "MODE", "+B") # OPTIMIZE
                        end
                       
                    end
                    
                elsif @authenticated
                    
                else
                    
                    
                end
            end
        
        end
        
        @connection.close
        
        # msg = ":cadance.canternet.org NOTICE Auth :*** Looking up your hostname..."
        # reggie = msg.match(IRC_MESSAGE_REGEX)
        
        # puts "Message is:\t#{msg}"
        # puts "Source  is:\t#{reggie[:source]}"Before continuing, let’s define self image. Also known as identity, self image is a mental model of ourselves. It arises when we identify with certain objects, places, ideas, etc. Common objects of identification are the body, thoughts, roles, family, possessions, values and tastes.  For example, my self image may be that of a middle class, intelligent, stoic person. Not too bad, but what is the problem?
        # puts "Commnd  is:\t#{reggie[:command]}"
        # puts "Params  is:\t#{reggie[:parameters]}"
        # puts "Append  is:\t#{reggie[:message]}"
        
        
    rescue Exception => e
        
        puts e.message
        puts e.backtrace.inspect 
        
    end
    
    def connect(server, port = 6667, server_password = nil)
        # TODO: Change to TCPSocket
        
        @server = server
        @port = port
        @server_password = server_password if server_password
        
        connection = TCPSocket.new(server, port)
        
        return connection
        
    end
    

    def authenticate(nick, account, password = nil, name = "Bonds IRCBot")
        
        @nick = nick
        @account = (account) ? account : nick
        @name = name
        @password = password
        
        @nick_regex = Regexp.new(Regexp.escape("#{@nick}"),"i")
        
        send_command(nil, NET_COMMANDS[:nick][0], "#{@nick}")
        send_command(nil, NET_COMMANDS[:user][0], "#{@account} 0 *", "#{@name}")
        send_command(nil, NET_COMMANDS[:authentication][0], "#{NET_COMMANDS[:authentication][1]} #{@account} #{@password}") if @password
        
        return true        
        
    end
    
    def send_command(source, command, parameters = nil, message = nil)
        
        case parameters
        when Array
            parameters = parameters.join(" ")
        when String,Integer
            parameters = parameters.to_s
        else
            parameters = ""
        end
        
        output = ((source)? ":#{source} " : "") << "#{command} " << "#{parameters} " << ((message)? ":#{message}" : "")
        
        puts outrecord = ">> #{output}"        
        @rawlog.info(outrecord)
        
        return @connection.puts(output)
        
    end
    
    def send_message(message,target,action = false)
    
        sentence = [message]
        
        if action
            sentence[0] = "#{CTCP_DELIMITER}ACTION #{sentence[0]}#{CTCP_DELIMITER}" 
        end
        
        send_command(nil,NET_COMMANDS[:message][0],target,"#{sentence[0]}")
    
    end
    
    def reply_message(message, sender_nick, channel = nil, pm = false)
        
        reply = nil
        commands = []
        
        to = (channel && !pm)? channel : sender_nick
        
        action = false
        
        case message
        when matched = Dice::SET_REGEX
            rolls = @dicebot.parse_set(message).collect{|r| r[:rolls][0]}
            reply = "#{sender_nick}: #{rolls.inject(:+)} #{rolls.to_s}"
            puts "Matched roll"
        when matched = /#{@nick_regex}#{CALL_REGEX}(?:go\s*to|join)\s+(?<channel>#{IRC_CHANNEL_REGEX})/i
            reply = "#{sender_nick}: on my way."
            commands.push([nil,NET_COMMANDS[:join][0],message.match(matched)[:channel],""])
            puts "Matched join"
        when matched = /#{@nick_regex}#{CALL_REGEX}(?:leave|go\s*away)/i
            reply = "#{sender_nick}: ;_;"
            commands.push([nil,NET_COMMANDS[:part][0],channel,"Nobody likes the bot..."])
            puts "Matched part"
        when matched = /#{@nick_regex}#{CALL_REGEX}(?:explode|die)/i
            reply = "#{sender_nick}: O_O"
            commands.push([nil,NET_COMMANDS[:quit][0],channel,"BITS FLY EVERYWHERE!!!"])
        when matched = /shakes #{@nick_regex}/i
            puts "Reseeding to #{@dicebot.reset_seed}"
            reply = "rattles 9_6"
            action = true       
        end
        
        send_message("#{reply}",to,action) if reply
        commands.each {|c| send_command(c[0],c[1],c[2],c[3])}
        
        
    end
    
end

IRC.new("BondsBot",nil,nil,"irc.canternet.org",6669)