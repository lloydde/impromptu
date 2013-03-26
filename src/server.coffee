path = require 'path'
net = require 'net'
spawn = require('child_process').spawn
CLI = require './cli'

# Create a new server.
server = net.createServer (connection) ->
  connection.on 'data', (input) ->
    input = input.toString().trim()
    if input == 'exit'
      process.exit()

    # Split the command back into its components.
    args = input.split '__IMPROMPTU__'

    # Build and run the command.
    new CLI
      args: args
      connection: connection
    .run()



# Generate the socket path for this process.
socketPath = path.resolve __dirname + '/../etc/' + process.pid + '.sock'
proxyPath = path.resolve __dirname + '/../bin/tu-proxy'

# Point the server at the socket.
server.listen socketPath, ->
  # When the server is connected, launch the proxied `tu` script.
  spawn proxyPath, [socketPath], {stdio: 'inherit'}