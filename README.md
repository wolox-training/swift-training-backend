# swift-training-backend

Backend for WBooks iOS Training, made entirely in Swift.
<br/><br/>

## Requirements
* Swift 4.x

## Documentation
* [Apiary](https://wbooksbackend.docs.apiary.io/): Here you will find all the information necessary to interact with the API.<br/><br/>


## API
The app is now running on Heroku. You can interact with it through this URL: <br/>
```
https://swift-training-backend.herokuapp.com/
```

### Example
```
curl https://swift-training-backend.herokuapp.com/books
```
<br/>


## DER

![alt text](https://github.com/wolox-training/swift-training-backend/blob/master/DER.png)
<br/>

## Running locally

First, set up the project with:
```
sh Scripts/complete_installation
```
<br/>

Once finished, you can start the app with:
```
vapor run
```
<br/>

If you want to fill the database with made-up data, keep the app running and exectute this on another terminal:
```
sh Scripts/insert_data
```
<br/>

All done! You're ready to start using the API :)

<br/>

## Deploying to Heroku

1) Install Heroku CLI:
```
brew install heroku/brew/heroku
```
<br/>

2) Log in to Heroku:
```
heroku login
```
<br/>

3) Ask your Team Leader to be added as a Collaborator. This will give you the proper permissions to push to the Heroku repository.
<br/>

4) After you have been added as a Collaborator, add the remote repository:
```
heroku git:remote -a swift-training-backend
```
<br/>

5) Well done! You are ready to deploy. In order to do so, run the following command:
```
vapor heroku push
```
<br/>

It might take a while, but in the meantime you can check out the build logs from the [Dashboard](https://dashboard.heroku.com/apps/swift-training-backend/activity).

<br/>

## Logs

You can show the remote logs with the following command:
```
heroku logs --tail
```

<br/>

## Issues with Xcode?

If Xcode doesn't show the correct files, or the project structure seems wrong, just run the following command:
```
vapor update -y
```
This will update the dependencies and generate the appropiate Xcode project files. Xcode will restart once the command finishes.

