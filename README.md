Chat Erlang
==========

Simple chat erlang.

### Prerequisites

You need to install [erlang](http://www.erlang.org).

## Getting Started

You need to enter the name of your machine to the node in `client.erl` file.

```erlang
Server = {server_chat, 'server@{MACHINE_NAME}'}
```

Compile files.

```bash
$ c(server).
$ c(client).
```

Start server

```bash
$ server:start().
```

Open other terminal in your path project and join client.

```bash
C = client:join({YOUR_NICK_NAME}).
```

To send message

```bash
C ! {send, "Hello world"}.
```bash

## Enjoy



## Authors

* **Vinícius Duarte Reis**

## Acknowledgments

* Teacher Rodrigo
