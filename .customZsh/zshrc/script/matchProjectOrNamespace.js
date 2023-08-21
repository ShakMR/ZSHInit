const fs = require("fs");

const main = () => {
    const arguments = getArguments().join(' ');
    const env = getEnvVars();

    const namespaces = readFile(env.namespacesDB);

    const isNamespace = doAnyNamespaceMatch({namespaces, query: arguments});

    if (isNamespace) {
        return getPathFromMatchingNamespace({namespaces, query: arguments});
    }

    const projects = readFile(env.projectsDB);

    const isProject = doAnyProjectMatch({projects, query: arguments});

    if (!isProject) {
        throw new Error("Neither project nor Namespace matches");
    }

    return getPathFromMatchingProject({projects, query: arguments});
}

const getArguments = () => {
    const args = process.argv.splice(2);

    if (args.length > 1) {
        moreArgumentsThanNeededError();
    } else if (args.length === 0) {
        notEnoughArguments();
    }

    return args;
}

const moreArgumentsThanNeededError = () => {
    throw new Error("More Arguments than needed");
}
const notEnoughArguments = () => {
    throw new Error("Expected 1 argument");
}

const getEnvVars = () => {
    return {
        namespacesDB: process.env.PROJECTS_NAMESPACES_DB_PATH,
        projectsDB: process.env.PROJECTS_DB_PATH,
    };
}

const readFile = (path) => fs.readFileSync(path, {encoding: 'utf-8'}).split('\n');

const doAnyNamespaceMatch = ({namespaces, query}) => doesAnyArrayItemIncludeTheQuery(namespaces, query);
const doAnyProjectMatch = ({projects, query}) => doesAnyArrayItemIncludeTheQuery(projects, query);

const doesAnyArrayItemIncludeTheQuery = (array, key) => array.some((item) => item.includes(key));

const getPathFromMatchingNamespace = ({namespaces, query}) => getMatchingItemInArray(query, namespaces);
const getPathFromMatchingProject = ({projects, query}) => getMatchingItemInArray(query, projects);

const getMatchingItemInArray = (key, array) => array.find((item) => item.includes(key))

console.log(main());