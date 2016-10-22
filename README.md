## Chat Erlang

Simple chat erlang.

### Prerequisites

You need to install erlang

## Getting Started

you need to enter the name of your machine to the node in client.erl

```
`Server = {server_chat, 'server@{MACHINE_NAME}'}`

Compile files.

`c(server).`
`c(client).`

Start server

`server:start().`

Open other terminal in your path project and join client.

`C = client:join({YOUR_NICK_NAME}).`

To send message

`C ! {send, "Hello world"}.`

## Enjoy

```

## Authors

* **Vinícius Duarte Reis**

## Acknowledgments

* Teacher Rodrigo
