#!/bin/bash

# Define the repository URL
REPO_URL="git@github.com:RevealGC/node-red-sync.git"

# Define the directory name
DIR_NAME="node-red-sync"

# Check if the directory exists
if [ -d "$DIR_NAME" ]; then
    echo "Directory '$DIR_NAME' already exists. Performing a pull..."
    cd "$DIR_NAME"
    git pull origin main
else
    echo "Directory '$DIR_NAME' does not exist. Cloning the repository..."
    git clone "$REPO_URL"
    cd "$DIR_NAME"
fi

# Replace package.json
echo '{
    "name": "node-red-project",
    "description": "A Node-RED Project",
    "version": "0.0.1",
    "private": true,
    "dependencies": {
        "@digitaloak/node-red-contrib-digitaloak-postgresql": "~0.3.2",
        "node-red-contrib-custom-chatgpt": "~1.2.11",
        "node-red-contrib-email": "~0.2.1",
        "node-red-contrib-fs": "~1.4.1",
        "node-red-contrib-kafka-client": "~0.1.0",
        "node-red-contrib-kafka-manager": "~0.5.1",
        "node-red-contrib-msg-speed": "~2.1.0",
        "node-red-contrib-re-postgres": "~0.3.4",
        "node-red-contrib-ui-etable": "~4.6.3",
        "node-red-contrib-uibuilder": "~6.0.0",
        "node-red-dashboard": "~3.3.1",
        "node-red-node-email": "~2.0.1",
        "node-red-node-ui-table": "~0.4.3"
    }
}' > package.json

# Create or update .gitignore
echo 'README.md
.npm
node_modules
package.json
uibuilder
lib
projects
*.backup
mc2_cred.json
package-lock.json
settings.js' > .gitignore

# Replace settings.js
echo 'module.exports = {
    flowFile: "flows.json",
    flowFilePretty: true,
    uiPort: process.env.PORT || 1880,
    diagnostics: {
        enabled: true,
        ui: true,
    },
    runtimeState: {
        enabled: false,
        ui: false,
    },
    logging: {
        console: {
            level: "info",
            metrics: false,
            audit: false
        }
    },
    exportGlobalContextKeys: false,
    externalModules: {},
    editorTheme: {
        palette: {},
        projects: {
            enabled: true,
            workflow: {
                mode: "manual"
            }
        },
        codeEditor: {
            lib: "monaco",
            options: {}
        },
        markdownEditor: {
            mermaid: {
                enabled: true
            }
        },
    },
    functionExternalModules: true,
    functionTimeout: 0,
    functionGlobalContext: {},
    debugMaxLength: 1000,
    mqttReconnectTime: 15000,
    serialReconnectTime: 15000,
}' > settings.js

# Run Node Red Locally
docker-compose down --remove-orphans && docker-compose up --build