require "socket"

server = gets.chomp

s = TCPSocket.new(server,6666)

while line = s.gets do
  puts line.chomp
end
