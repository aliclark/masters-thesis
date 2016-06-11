
Goals
-----

 * Be able to stream data over QUIC between client and server C
   programs, using an event_base created by the client and server
   programs

Current status
--------------

 * Can compile QUIC, including a basic C interface to its demo code.

 * Can link the QUIC libraries into a C program and call the QUIC demo
   code.

TODO
----

 * Create the event_base instance from C and pass it into QUIC

 * Modify server and client to allow streaming

Lessons learned
---------------

 * `net/tools/quic/quic_simple_{client,server}_bin.cc` uses a libevent
   instance, while `net/tools/quic/quic_{client,server}_bin.cc` is the
   epoll variant

 * For the simple variant, trying to use `-levent` causes a currently
   uninvestigated runtime issue. Instead
   `third_party/libevent/libevent.a` must be used.

 * The epoll variant only uses libevent for epoll shim functions, so
   can use `-levent` (or probably just copying the shim code).

 * For now, my plan is to try to initialise the simple variant using
   an event_base from the C programs. A better approach in future
   might be to use epoll variant (probably more performant) in its own
   thread, and some mechanism to pass data to and from it.

   * However, a multi-threaded impl would likely require more work to
     run Shadow network tests against it

 * The demo programs are based on a SPDY request, response
   cycle. Further work will be needed to reach an impl that allows
   streaming.

Build and Run
-------------

Feel free to submit an issue on this project if anything here doesn't work

```sh
# install git curl g++ pkg-config libglib2.0-dev libnss3-tools

git clone https://github.com/aliclark/proto-quic
git clone https://github.com/aliclark/masters-thesis

export PATH=$PATH:$(pwd)/proto-quic/depot_tools
cd proto-quic/src/
gclient runhooks
ninja -C out/Debug quic_server quic_client
cd -

cd masters-thesis/basic-c-program/
cd certs
./generate-certs.sh
cd ..

./make-server.sh
./make-client.sh

./build/test_server --v=1 --quic_in_memory_cache_dir=www.example.org --certificate_file=certs/out/leaf_cert.pem --key_file=certs/out/leaf_cert.pkcs8

# This will fail, since the root certificate is not installed yet...
./build/test_client --host=127.0.0.1 --port=6121 https://www.example.org/

# Nb. the test_server command above will have auto-created ~/.pki/nssdb if it didn't exist yet
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n QUIC-TEST-3DAYS-$(date +%Y%m%d) -i certs/out/2048-sha256-root.pem

# Restart test_server...
./build/test_server --v=1 --quic_in_memory_cache_dir=www.example.org --certificate_file=certs/out/leaf_cert.pem --key_file=certs/out/leaf_cert.pkcs8

# Should work this time
./build/test_client --host=127.0.0.1 --port=6121 https://www.example.org/
```
