## Chat Erlang

Simple chat erlang.

### Prerequisites

You need to install erlang

## Getting Started

1. You need to enter the name of your machine to the node in `client.erl` file.

`Server = {server_chat, 'server@{MACHINE_NAME}'}`

2. Compile files.

`c(server).`
`c(client).`

3. Start server

`server:start().`

4. Open other terminal in your path project and join client.

`C = client:join({YOUR_NICK_NAME}).`

5. To send message

`C ! {send, "Hello world"}.`

## Enjoy



## Authors

* **Vinícius Duarte Reis**

## Acknowledgments

* Teacher Rodrigo
