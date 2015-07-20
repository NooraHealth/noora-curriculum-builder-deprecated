Meteor.startup ()->
  bucket = Meteor.call "getBucket"
  Slingshot.createDirective "s3", Slingshot.S3Storage, {
    bucket: bucket,
    acl: "public-read",
    AWSAccessKeyId: process.env.AWS_ACCESS_KEY_ID,
    AWSSecretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    region: REGION,
    authorize: () ->
      #Deny uploads if user is not logged in
      if not Meteor.user()?
        message = "Please login before posting files"
        throw new Meteor.Error("Login Required", message)

      return true

    key:(file) ->
      return Meteor.filePrefix(file)
  }

  AWS.config.update
    bucket: bucket
    region: REGION
    apiVersion: '2006-03-01'
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY

###  
  s3.listBuckets (err, data)->
    if err
      console.log err, err.stack
    else 
      console.log data
###

 



