const fs = require("fs");

const main = () => {
    const { query, debug } = parseArguments();
    const env = getEnvVars();

    debugLog(debug, {
        cwd: process.cwd(),
        query,
        env,
        processEnv: {
            PROJECTS_NAMESPACES_DB_PATH: process.env.PROJECTS_NAMESPACES_DB_PATH,
            PROJECTS_DB_PATH: process.env.PROJECTS_DB_PATH,
        },
    });

    const namespaces = readFile(env.namespacesDB);

    debugLog(debug, {
        namespacesDB: describeLoadedDb(env.namespacesDB, namespaces),
    });

    const namespaceResult = findExistingMatchAndPruneMissing({
        entries: namespaces,
        query,
        dbPath: env.namespacesDB,
        debug,
        kind: "namespace",
    });

    if (namespaceResult) {
        debugLog(debug, { branch: "namespace", result: namespaceResult });
        return namespaceResult;
    }

    const projects = readFile(env.projectsDB);

    debugLog(debug, {
        projectsDB: describeLoadedDb(env.projectsDB, projects),
    });

    const projectResult = findExistingMatchAndPruneMissing({
        entries: projects,
        query,
        dbPath: env.projectsDB,
        debug,
        kind: "project",
    });

    if (!projectResult) {
        debugLog(debug, { branch: "none", result: null });
        throw new Error("Neither project nor Namespace matches");
    }

    debugLog(debug, { branch: "project", result: projectResult });
    return projectResult;
}

const parseArguments = () => {
    const args = process.argv.splice(2);
    const debug = args.includes("--debug") || args.includes("-d");
    const queryArgs = args.filter((arg) => arg !== "--debug" && arg !== "-d");

    if (queryArgs.length > 1) {
        moreArgumentsThanNeededError();
    } else if (queryArgs.length === 0) {
        notEnoughArguments();
    }

    return {
        query: queryArgs.join(" "),
        debug,
    };
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

const writeDb = (path, entries) => {
    fs.writeFileSync(path, entries.join('\n'), {encoding: 'utf-8'});
}

const describeLoadedDb = (path, lines) => ({
    path,
    exists: true,
    lineCount: lines.length,
});

const debugLog = (debug, payload) => {
    if (!debug) {
        return;
    }

    console.error("[debug]", JSON.stringify(payload, null, 2));
}

const findExistingMatchAndPruneMissing = ({entries, query, dbPath, debug, kind}) => {
    const matchingEntries = getAllMatchingItemsInArray(query, entries);

    for (const entry of matchingEntries) {
        if (fs.existsSync(entry)) {
            return entry;
        }

        debugLog(debug, {
            pruned: {
                kind,
                path: entry,
                reason: "path does not exist on filesystem",
            },
        });

        removeEntryFromDb({entries, entry, dbPath});
    }

    return null;
}

const removeEntryFromDb = ({entries, entry, dbPath}) => {
    const index = entries.indexOf(entry);

    if (index === -1) {
        return;
    }

    entries.splice(index, 1);
    writeDb(dbPath, entries);
}

const getAllMatchingItemsInArray = (key, array) => array.filter((item) => item.includes(key));

console.log(main());
