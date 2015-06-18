Meteor.methods {
  deleteLesson: (id)->
    console.log "Deleting the lesson"
    lesson = Lessons.findOne {_id: id}
    #delete the modules
    Meteor.call "removeAllModules", lesson
    #delete the lesson
    Lessons.remove {_id: id}
    #remove from curriculum
    curriculum = Meteor.getStubCurriculum()
    lessons= curriculum.lessons
    newLessons = (lesson for lesson in lessons when lesson is not id )
    Curriculum.update {_id: curriculum._id}, {$set: {lessons: newLessons}}

  removeAllModules: (lesson)->
    for module in lesson.modules
      Modules.remove {_id:module}

  appendModule: (lessonId, moduleId)->
    Lessons.update {_id: lessonId}, {$push: {"modules":moduleId}}
    console.log Lessons.findOne {_id: lessonId}

  appendLesson: ( curriculumId, lessonId)->
    Curriculum.update {_id: curriculumId}, {$push: {"lessons":lessonId}}
    console.log Curriculum.findOne {_id: curriculumId}

  getBucket: ()->
    if process.env.METEOR_ENV == 'production'
      return BUCKET
    else
      return DEV_BUCKET

  contentEndpoint: ()->
    if process.env.METEOR_ENV == 'production'
      return "https://noorahealthcontent.s3-us-west-1.amazonaws.com/"
    else
      return 'https://noorahealth-development.s3-us-west-1.amazonaws.com/'

}
