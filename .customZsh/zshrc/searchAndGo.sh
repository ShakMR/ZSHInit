export PROJECTS_HOME=~/Projects

updateProjectsDB() {
    PROJECTS_DB=$(locate ${PROJECTS_HOME}/*/.git | grep -v node_modules | sed 's/\/.git//')
    rm -f /tmp/projects_db
    echo ${PROJECTS_DB} > /tmp/projects_db
}

getProjects() {
    if [[ ! -f /tmp/projects_db ]]; then updateProjectsDB; fi
    cat /tmp/projects_db | rev | cut -d'/' -f1 | rev
}

go() {
    if [[ ! -f /tmp/projects_db ]]; then updateProjectsDB; fi
    cd $(cat /tmp/projects_db | grep ${@}$)
}
