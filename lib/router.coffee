Router.map ()->

  this.route '/', {
    path: '/'
    template: 'curriculumBuilder'
    layoutTemplate:'layout'
    data: ()->
      console.log "in the home data"
      uploaders = Uploaders.find({})
      return {uploaders: uploaders}
  }

  this.route("webapp", {where: 'server'}).get ()->
    this.response.writeHead 302, {
      'Location': WEBAPP_URL
    }
    this.response.end()



