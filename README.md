# Queue-Count-Logging

This is just a simple scheduled task and persistent class to log queue counts in a production. 
Set it up like any other scheduled task and make sure to specify the production name.

# Installation

```
#git clone repository

Open the folder in VSCode with InterSystems ObjectScript support.

#docker-compose build

#docker-compose up -d

#docker-compose exec iris iris session iris

USER>zn "QLOG"
QLOG>"run the code"

```

After that you'll be able to edit and compile libraries in VSCode as well

