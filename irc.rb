#coding: UTF-8

# require "socket"

# server = gets.chomp

# s = TCPSocket.new(server,6666)

# while line = s.gets do
#   puts line.chomp
# end

# ^[#!&\+]+[\w\-\|\[\]\{\}`^]+$

# ^(?:[\<\>]{2})(?: :([\w\-\|\[\]\{\}`^]*?(?:![\w\.\-\~]+)?(?:@)?(?:\w[\w\.\-]+[\.][\w\.\-]+\w)?)|()) ([a-zA-Z0-9]*) ([^:]*)(?::(.*))?$
# (?:[\<\>]{2}) input/output prefix
# [\w\-\|\[\]\{\}`^]*? attempts to retrieve Nick, only matching if nothing else does
# (?:![\w\.\-\~]+)? tries to match Account name, if it exists
# (?:@)?(?:\w[\w\.\-]+[\.][\w\.\-]+\w)? tries to match host, if it exists
# ([a-zA-Z0-9])* matches command name
# ([^:]*) Matches middle parameters
# (?::(.*))?$ Matches trailing text, if it exists

log = File.new("irclog.txt","r")
parse = File.new("ircparse.txt","w")
pattern = /^(?:[\<\>]{2})(?: :([\w\-\|\[\]\{\}`^]*?(?:![\w\.\-\~]+)?(?:@)?(?:\w[\w\.\-]+[\.][\w\.\-]+\w)?)|) ([a-zA-Z0-9]*) ([^:]*)(?::(.*))?$/

for i in 1..890
    line = log.gets.chomp
    matched = pattern.match(line)
    parse.puts()
    (0..4).collect { |j| parse.puts("#{(j!=0)?j:((pattern =~ line)?'Matched':'ERROR!!!')}: #{matched[j]}") }
    # puts (pattern =~ line)?"Matched":"No"
    # puts pattern.match(line)[0]
    # puts "1: #{pattern.match(line)[1]}"
    # puts "2: #{pattern.match(line)[2]}"
    # puts "3: #{pattern.match(line)[3]}"
    # puts "4: #{pattern.match(line)[4]}"
end