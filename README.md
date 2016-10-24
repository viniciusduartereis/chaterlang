Chat Erlang
==========

Simple erlang chat for messages between nodes.

### Prerequisites

You need to install [erlang](http://www.erlang.org).

## Getting Started

You need to enter the name of your machine to the node in `client.erl` file.

```erlang
Server = {server_chat, 'server@{MACHINE_NAME}'},
```

Go to yout path project, and start node server

```bash
$ erl -sname server
```

Compile files.

```bash
> c(server).
> c(client).
```

Start server
```bash
> server:start().
```

Open other terminal in your path project and join client.

```bash
$ erl -sname client
> C = client:join({NICK_NAME}).
```

To send message

```bash
> C ! {send, "Hello world"}.
```

### Enjoy


## Authors

* Vinícius Duarte Reis

## Acknowledgments

* **Teacher Rodrigo Freitas**