require 'sinatra'
require 'em-websocket'

@@websocket_server

get '/' do
  erb :dash
end

get '/update_frame' do
  erb :update_frame
end

post '/update_frame' do
    @@websocket_server.send "data = {frame_id:0, size:#{params[:size]}," + 
			"x:#{params[:x]} ," +
			" y:#{params[:y]}," +
			" color:'" + params[:color]+ "'," +
			" text:'" + params[:text]+ "'}"
   erb :update_frame
end

configure do
  Thread.new {
    EM.run {
      EM::WebSocket.run(:host => "0.0.0.0", :port => 9876) do |ws|
        @@websocket_server = ws
        @@websocket_server.onopen { |handshake|
          puts "WebSocket connection open"

          # Access properties on the EM::WebSocket::Handshake object, e.g.
          # path, query_string, origin, headers

          @@websocket_server.send "data = 'Hello Client, you connected !!! to #{handshake.path}'"
        }

        @@websocket_server.onclose { puts "Connection closed" }

        @@websocket_server.onmessage { |msg|
          puts "Recieved message: #{msg}"
          ws.send "data = 'Pong: #{msg}'"
        }
      end
    }
  }
end
