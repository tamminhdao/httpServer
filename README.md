# Swift Server

### Project Requirements

* Swift 4.0
* Java 8 (to run Cob_spec suite of acceptance tests) 

### Generate xcode project

From the root folder:
```
swift package generate-xcodeproj
swift build
```

### Run the code

```./.build/debug/CobSpec -p <port number> -d <directory path>```


### Run the unit tests

```
swift build
swift test
```

### Run Cob_spec suite of acceptance tests

From the root folder:
```
cd cob_spec
mvn package
java -jar fitnesse.jar -c 'PassingTestSuite?suite&format=text'
```

