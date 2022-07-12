# Answers to tasks

### How to run applications:

* ***Firstly, build PatternSearch application:*** <br/>

    >cd ./answer/Task1/PatternSearch <br/>
    chmod +x gradlew <br/>
    ./gradlew build eclipse
* ***Secondly, run PatternSearch application in the Eclipse IDE:*** <br/>
    In the Package Explorer: PatternSearch -> launches -> PatternSearch.launch (right click of mouse) -> Run As -> PatternSearch <br/>

### Functions

* ***Split Function*** <br/>
Link to the function: https://5npswa17la.execute-api.us-east-1.amazonaws.com/Split. <br/>
    >Example: curl -X POST 'https://5npswa17la.execute-api.us-east-1.amazonaws.com/Split' -H "Content-Type: application/json" -d '{"originalStr": "one one one two one", "batchSize": 2}' <br/>
       
   >Parameters: <br/>
        **originalStr** - required, type - string <br/>
        **batchSize** - required, type - int <br/>

* ***Count Function*** <br/>
Link to the function: https://4bj9sgtt07.execute-api.us-east-1.amazonaws.com/Count. <br/>
    >Example: curl -X POST 'https://4bj9sgtt07.execute-api.us-east-1.amazonaws.com/Count' -H "Content-Type: application/json" -d '{"batch": ["one", "one"], "pattern": "one"}' <br/>
       
   >Parameters: <br/>
        **batch** - required, type - array <br/>
        **pattern** - required, type - string <br/>

* ***Assemble Function*** <br/>
Link to the function: https://0pyk2eyx72.execute-api.us-east-1.amazonaws.com/Assemble. <br/>
    >Example: curl -X POST 'https://0pyk2eyx72.execute-api.us-east-1.amazonaws.com/Assemble' -H "Content-Type: application/json" -d '{"counterValueArray": [1, 2, 3, 4]}' <br/>
       
   >Parameters: <br/>
        **counterValueArray** - required, type - array <br/>

* ***SplitSecond Function*** <br/>
Link to the function: https://bp4rqdvb74.execute-api.us-east-1.amazonaws.com/SplitSecond. <br/>
    >Example: curl -X POST 'https://bp4rqdvb74.execute-api.us-east-1.amazonaws.com/SplitSecond' -H "Content-Type: application/json" -d '{"originalStr": "one one one two one", "pattern": "one", "batchSize": 2, "threshold": 2}' <br/>
       
   >Parameters: <br/>
        **originalStr** - required, type - array <br/>
        **pattern** - required, type - string <br/>
        **batchSize** - required, type - int <br/>
        **threshold** - required, type - int <br/>

* ***Modify Function*** <br/>
Link to the function: https://d1r6ma2lyb.execute-api.us-east-1.amazonaws.com/Modify. <br/>
    >Example: curl -X POST 'https://d1r6ma2lyb.execute-api.us-east-1.amazonaws.com/Modify' -H "Content-Type: application/json" -d '{"batch": ["one", "two"], "pattern": "one"}' <br/>
       
   >Parameters: <br/>
        **batch** - required, type - array <br/>
        **pattern** - required, type - string <br/>

* ***AssembleSecond Function*** <br/>
Link to the function: https://u1vjskaapb.execute-api.us-east-1.amazonaws.com/AssembleSecond. <br/>
    >Example: curl -X POST 'https://u1vjskaapb.execute-api.us-east-1.amazonaws.com/AssembleSecond' -H "Content-Type: application/json" -d '{"modifiedArray": ["two", ""], "thresholdStr": "one one"}' <br/>
       
   >Parameters: <br/>
        **modifiedArray** - required, type - array <br/>
        **thresholdStr** - required, type - string <br/>


### Commands for building SC-Core

**Note:** If you have problem with library SC-Core-main-SNAPSHOT.jar (link to the repository: https://github.com/denisrogovoy/SC-Core), you can build it manually using example of commands below. <br/>

>cd ./SC-Core <br/>
gradle build <br/>

>cd ./answer/Task1/PatternSearch <br/>
cp -R * /home/denis/libs/ <br/>

>cd /home/denis/.gradle/caches/modules-2/files-2.1/com.github.denisrogovoy/SC-Core/main-SNAPSHOT/58243bfa9b55f3b0e469deb032ee18254678af47 <br/>
cp /home/denis/libs/SC-Core-sources.jar ./ <br/>
chown denis:denis SC-Core-sources.jar <br/>
chmod 664 SC-Core-sources.jar <br/>
rm SC-Core-main-SNAPSHOT-sources.jar <br/>
mv ./SC-Core-sources.jar SC-Core-main-SNAPSHOT-sources.jar <br/>

>cd /home/denis/.gradle/caches/modules-2/files-2.1/com.github.denisrogovoy/SC-Core/main-SNAPSHOT/bce4c42dad52b29e8d8ba4148c08f91569e82aac <br/>
cp /home/denis/libs/SC-Core.jar ./ <br/>
chown denis:denis SC-Core.jar <br/>
chmod 664 SC-Core.jar <br/>
rm SC-Core-main-SNAPSHOT.jar <br/>
mv SC-Core.jar SC-Core-main-SNAPSHOT.jar <br/>
