# swift-training-backend

Backend for WBooks iOS Training, made entirely in Swift.

## Requirements
* Swift 4.x

## Documentation
* [Apiary](https://wbooksbackend.docs.apiary.io/): Here you will find all the information necessary to interact with the API.<br/><br/>


## API
The app is now running on Heroku. You can interact with it through this URL: <br/>
```
https://powerful-waters-21107.herokuapp.com/
```

### Example
```
curl https://powerful-waters-21107.herokuapp.com/books
```
<br/>


## DER

![alt text](https://raw.githubusercontent.com/gmazzei/WBooksBackend/master/DER.png)
<br/>

## Running locally

1) Install Vapor
```
brew install vapor/tap/vapor
```

<br/>

2) Install PostgreSQL
```
brew install postgres
brew services start postgresql
```
<br/>

3) Prepare the DB
```
createuser postgres -s
createdb wbooks -O postgres
```
<br/>

4) Clone and start the app
```
git clone git@github.com:wolox-training/swift-training-backend.git
cd swift-training-backend
vapor update -y
swift build
swift run
```
<br/>

5) Open another terminal and run the following code to add data into the DB:
```
sh Scripts/create_db
```
