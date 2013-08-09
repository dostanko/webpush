require 'sinatra'
require 'em-websocket'

@websocket_alive = false

get '/' do
  Thread.new { start_websoket} if !@websocket_alive
  erb :dash
end

def start_websoket
  EM.run {
    EM::WebSocket.run(:host => "0.0.0.0", :port => 9876) do |ws|
      ws.onopen { |handshake|
        puts "WebSocket connection open"

        # Access properties on the EM::WebSocket::Handshake object, e.g.
        # path, query_string, origin, headers

        ws.send "Hello Client, you connected !!! to #{handshake.path}"
      }

      ws.onclose { puts "Connection closed" }

      ws.onmessage { |msg|
        puts "Recieved message: #{msg}"
        ws.send "Pong: #{msg}"
      }
    end
  }
end
