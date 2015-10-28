class Ichiban.Models.Post extends Backbone.Model
  paramRoot: 'post'

class Ichiban.Collections.PostsCollection extends Backbone.Collection
  model: Ichiban.Models.Post
  url: '/posts'