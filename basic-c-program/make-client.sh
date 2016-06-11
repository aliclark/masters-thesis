#!/bin/sh

proto_quic_src=$HOME/proto-quic/src

mkdir -p build

cc \
    -o build/test_client \
    -I$proto_quic_src \
    src/test_client.c \
    $proto_quic_src/out/Debug/obj/net/libsimple_quic_tools.a \
    $proto_quic_src/out/Debug/obj/net/libnet.a \
    \
    $proto_quic_src/out/Debug/obj/crypto/libcrcrypto.a \
    $proto_quic_src/out/Debug/obj/base/libbase.a \
    $proto_quic_src/out/Debug/obj/base/libbase_static.a \
    $proto_quic_src/out/Debug/obj/base/libsymbolize.a \
    $proto_quic_src/out/Debug/obj/base/allocator/liballocator.a \
    $proto_quic_src/out/Debug/obj/base/third_party/dynamic_annotations/libdynamic_annotations.a \
    $proto_quic_src/out/Debug/obj/base/third_party/libevent/libevent.a \
    $proto_quic_src/out/Debug/obj/url/liburl_lib.a \
    $proto_quic_src/out/Debug/obj/sdch/libsdch.a \
    \
    $proto_quic_src/out/Debug/obj/third_party/boringssl/libboringssl.a \
    $proto_quic_src/out/Debug/obj/third_party/boringssl/libboringssl_asm.a \
    $proto_quic_src/out/Debug/obj/third_party/icu/libicuuc.a \
    $proto_quic_src/out/Debug/obj/third_party/zlib/libchrome_zlib.a \
    $proto_quic_src/out/Debug/obj/third_party/zlib/libzlib_x86_simd.a \
    $proto_quic_src/out/Debug/obj/third_party/brotli/libbrotli.a \
    $proto_quic_src/out/Debug/obj/third_party/modp_b64/libmodp_b64.a \
    -lglib-2.0 -lsmime3 -lnssutil3 -lnss3 -lnspr4 -lstdc++ -lm -lpthread -ldl
