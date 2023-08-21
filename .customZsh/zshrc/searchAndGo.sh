export PROJECTS_HOME=~/Projects
export PROJECTS_DB_PATH=~/.customZsh/projects_db
export PROJECTS_NAMESPACES_DB_PATH=~/.customZsh/projects_ns_db
export DIR=~/.customZsh/zshrc/

updateProjectsDB() {
   PROJECTS_DB=$(find ${PROJECTS_HOME} -name .git -type d -prune -not -path "*/node_modules/*" | sed 's/\/.git//')
   rm -f ${PROJECTS_DB_PATH}
   echo ${PROJECTS_DB} > ${PROJECTS_DB_PATH}
   _updateProjectsNamespaceDB $PROJECTS_DB
}

_updateProjectsNamespaceDB() {
  rm -f ${PROJECTS_NAMESPACES_DB_PATH}
  getNamespacesPaths > ${PROJECTS_NAMESPACES_DB_PATH}
}

getProjects() {
    if [[ ! -f ${PROJECTS_DB_PATH} ]]; then updateProjectsDB; fi
    cat ${PROJECTS_DB_PATH} | rev | cut -d'/' -f1 | rev
}

getNamespaces() {
  cat ${PROJECTS_NAMESPACES_DB_PATH} | rev | cut -d'/' -f1 | rev
}

getNamespacesPaths() {
    cat ${PROJECTS_DB_PATH} | sed -e "s@$PROJECTS_HOME@@g" | cut -d '/' -f2 | uniq | sed -e "s@^@$PROJECTS_HOME/@"
}

getNamespacePath() {
  echo $1 | sed -e "s@\($PROJECT_HOME\)/\(.*\)/.*\$@\1/\2@"
}

goto() {
   arguments="$@"
   matchedEntries=$(node $DIR/script/matchProjectOrNamespace.js "${arguments}")
   echo "found " $matchedEntries
   cd "$matchedEntries"
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
    getNamespacePath ${projectPath} >> ${PROJECTS_NAMESPACES_DB_PATH}
}

