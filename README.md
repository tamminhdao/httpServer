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
*Generate an xcode project is not required to run the code or the tests


### Run the code

```
swift build
./run.sh -p <port number> -d <directory path>
```
*The directory path has to be an absolute path


### Run the unit tests

```
swift build
swift test
```
*Running these test command from anywhere other than the root folder would cause a few directory related tests to fail


### Run Cob_spec suite of acceptance tests

```
cd cob_spec
mvn package
java -jar fitnesse.jar -c 'PassingTestSuite?suite&format=text'
```


### Clone, build and run the server on AWS
```
cd ansible
ansible-playbook -i hosts playbook.yml
```
*Without the correct credentials for the AWS instance, the ansible playbook would not work
 
