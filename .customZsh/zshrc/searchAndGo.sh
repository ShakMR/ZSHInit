export PROJECTS_HOME=~/Projects
export PROJECTS_DB_PATH=~/.customZsh/projects_db

updateProjectsDB() {
   newCommand=$(find Projects -name .git -type d -prune -not -path "*/node_modules/*" | sed 's/\/.git//')
   rm -f ${PROJECTS_DB_PATH}
   echo ${PROJECTS_DB} > ${PROJECTS_DB_PATH}
}

getProjects() {
    if [[ ! -f ${PROJECTS_DB_PATH} ]]; then updateProjectsDB; fi
    cat ${PROJECTS_DB_PATH} | rev | cut -d'/' -f1 | rev
}

goto() {
    if [[ ! -f ${PROJECTS_DB_PATH} ]]; then updateProjectsDB; fi
    cd $(cat ${PROJECTS_DB_PATH} | grep ${@}\$)
}

addProject() {
    projectPath=${PWD};

    if [[ $# -ge 0 ]]; then
        firstChar=${1[1,1]}
        if [[ ${firstChar} != "/" ]]; then
            projectPath=${PWD}/${1}
        else
            projectPath=${1}
        fi
    fi

    echo ${projectPath} >> ${PROJECTS_DB_PATH}
}

