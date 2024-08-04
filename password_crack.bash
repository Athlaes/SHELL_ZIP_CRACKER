#!/bin/dash

characters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:',.<>?/~\`\"\\"

password="a"

log() {
    s="$1"
    echo "$s" >> log_password.txt
}

next_char_index() {
    char="$1"
    for ((i = 0; i < ${#characters}; i++)); do
        if [ "${characters:i:1}" == "$char" ]; then
            echo "$(( i + 1 ))"
            exit 0
        fi
    done
    exit 0
}

incr_password() {
    pwd="$1"
    length="${#pwd}"
    characters_index=$((length - 1))
    incr=false
    while [ "$incr" == false ]; do
        current_char=${pwd:characters_index:1}
        if [ "$current_char" != "\\" ]; then
            next_char_index="$(next_char_index "$current_char")"
            next_char="${characters:next_char_index:1}"
            pwd="${pwd:0:characters_index}$next_char${pwd:$(( characters_index + 1 )):${#pwd}}"
            incr=true
        else
            pwd="${pwd:0:characters_index}a${pwd:$(( characters_index + 1 )):${#pwd}}"
            if [ "$characters_index" == 0 ]; then 
                pwd="a$pwd"
                incr=true
            fi
        fi
        characters_index=$(( characters_index - 1 ))
    done
    printf "%s" "$pwd"
    exit 0
}

while true; do
    printf "a\n" | 7z t "$1" -p"$password"
    exitcode=$?
    if [ "$exitcode" == 0 ]; then
        echo "Crack done, password : $password" > result.txt
        exit 0
    fi;
    password="$(incr_password "$password")"
    log "$password"
    if [ "$password" == "" ]; then
        exit 1
    fi
done