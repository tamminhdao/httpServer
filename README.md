# Swift Server

### Project Requirements

* Swift 4.0
* Java 8 (to run Cob_spec suite of acceptance tests) 

### Generate xcode project

```
`cd` to the root folder
swift package generate-xcodeproj
swift build
```

### Run the code

```./.build/debug/Main -p <port number> -d <directory path>```
e.g: ```./.build/debug/Main -p 5000 -d ./cob_spec/public```

### Run the unit tests

```swift test```

### Run Cob_spec suite of acceptance tests
```
From the root folder: cd cob_spec
mvn package
java -jar fitnesse.jar -c 'PassingTestSuite?suite&format=text'
```

