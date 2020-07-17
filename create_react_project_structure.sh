#!/bin/bash
#fail on error

printf "This is going to create a React-Redux project with Rails-style: separate folders for “actions”, “constants”, “reducers”, “containers”, and “components.\nIt will also create files which I find use in most of my React Projects\nReference: https://redux.js.org/faq/code-structure"

usage() {
    echo "Usage: $0 -n <Project Name>" 1>&2
    exit 1
}

function has-space() {
    [[ "$1" != "${1%[[:space:]]*}" ]] && return 0 || return 1
}

which npm
if [ $? -ne 0 ]
then
    echo "npm needs to be installed \n please install the latest version of npm"
    exit 69
fi

while getopts "n:" opt; do
    case ${opt} in
        n)
            project_name=${OPTARG}
        ;;
    esac
done

if [ -z $project_name ]
then
    usage
    exit 69
fi

if has-space "$project_name"; then
    printf "Whitespace found in project name, no Whitespaces allowed in a name. Use camel or snake case instead!"
    exit 69
fi

npx create-react-app "$project_name"

# Declare an array of folders to create
declare -a StringArray=("actions" "assets" "components" "containers" "helpers" "reducers" )

#create .env file
printf "Creating .env file and adding default constants"

cd $project_name
touch .env
echo "REACT_APP_DEV_BACKEND_URL = dev endpoint" >> .env
echo "REACT_APP_PRD_BACKEND_URL = prd endpoint" >> .env

# navigate to the src folder of the react app and create these sub-folders
cd $project_name
cd src

for val in ${StringArray[@]}; do
    printf "Creating $val sub-folder"
    mkdir "$val"
done

#create a js file to hold urls constants
printf "Creating urls.js file..."
touch urls.js

printf "Your react-redux folder structure has been created"