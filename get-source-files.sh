
ll=$1

if [ "$#" -ne 1 ]; then
    echo "usage: $0 ll-file"
    exit 1
fi

ag -o --nofilename --nonumber 'filename: "[^/][^.]*\.[hc]"' $ll |
sed -e 's/filename: "\(.*\)"/\1/'                               |
sed -e 's/^\.\/\(.*\)/\1/'                                      |
# parse-datetime.c appears without the 'lib'                    |
sed -e 's/^parse-datetime.c$/lib\/parse-datetime.c/'            |
sort                                                            |
uniq                                                            ;
