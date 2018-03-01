# Swift Server

### Project Requirements

* Swift 4.0
* Java 8 (to run Cob_spec suite of acceptance tests) 

### Clone the repo
```
git clone https://github.com/tamminhdao/httpServer
```
Navigate into the repo and pull the submodule
```
cd httpServer
git submodule init
git submodule update
```

### Generate xcode project

```
swift package generate-xcodeproj
```

### Run the code

```
swift build
./.build/debug/CobSpec -p <port number> -d <directory path>
```


### Run the unit tests

```
swift build
swift test
```

### Run Cob_spec suite of acceptance tests

```
cd cob_spec
mvn package
java -jar fitnesse.jar -c 'PassingTestSuite?suite&format=text'
```

