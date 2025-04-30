function echoErr {
    echo "$1" >&2
}

function echoRed {
    echo "\033[0;31m$1\033[0m" >&2
}

function echoYellow {
    echo "\033[0;33m$1\033[0m" >&2
}

function echoGreen {
    echo "\033[0;32m$1\033[0m" >&2
}

TEMP_RESEARCH_TEMPLATES_FILE=temp.txt