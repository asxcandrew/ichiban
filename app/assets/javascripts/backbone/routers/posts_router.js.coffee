class Ichiban.Routers.PostsRouter extends Backbone.Router

  initialize: (options) ->
    @posts = new Ichiban.Collections.PostsCollection()
    @posts.reset options.posts

  routes:
    "index"       : "index"
    "new"         : "newPost"
    ":id"         : "show"
    ":id/edit"    : "edit"
    ".*"          : "index"

  index: ->
    @view = new Ichiban.Views.PostsIndexView({collection: @posts})

  newPost: ->
    @view = new Ichiban.Views.PostsNewView({collection: @posts})

  show: (id) ->
    post = @posts.get(id)
    @view = new Ichiban.Views.PostsShowView({model: post})

  edit: (id) ->
    post = @posts.get(id)
    @view = new Ichiban.Views.PostsEditView({model: post})