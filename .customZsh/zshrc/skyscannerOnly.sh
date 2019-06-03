export MSHELL_SKIP_DOCKER_LOGIN=true
export GIT_BASE=git@github.skyscannertools.net:adverts

clone () {
	git clone ${GIT_BASE}:$1/$2.git
}

syncProdToLocal() {
    echo "Copying production to file system"
    mongoexport --host localhost --port 27018 --db sponsored_service --collection $1 --out /tmp/sponsored/$1 --sslAllowInvalidHostnames --ssl --sslCAFile rds-combined-ca-bundle.pem --username strevdaAdmin --password ${DOCUMENT_DB_PASS}
    echo "Restoring production document into local"
    mongoimport --host localhost --port 27017 --drop --mode=upsert --db sponsored_service --collection $1 /tmp/sponsored/$1
}
