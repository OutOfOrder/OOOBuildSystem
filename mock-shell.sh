#!/bin/bash

if [ -r ./mock-config.txt ]; then
    . ./mock-config.txt
else
    echo "Missig mock-config.txt"
    exit 1
fi

mock -r $ROOT -n --disable-plugin=root_cache --disable-plugin=tmpfs --unpriv --shell "$@"
