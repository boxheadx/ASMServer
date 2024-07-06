# ASM Server

A server written in pure x86 assembly using kernel syscalls. Right now it uses multiprocessing using the fork syscall for each client connection which i think is a bad idea. I probably should use the select syscall to make this shit asynchronous as suggested by mrmojo2. I'd like to then create a Web server out of this.

## How to run

* First assemble the source

```bash
./assemble.sh
```

* Run the server

```bash
./bin/server
```

> Requires: nasm assembler

