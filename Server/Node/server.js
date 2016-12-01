var express = require('express')
var Sequelize = require('sequelize')
var cors = require('cors')
var bodyParser = require('body-parser')

var app = express()

var DB_NAME = 'gueramian'
var DB_USER = 'gueramian'
var DB_PASSWORD = 'node node 2016'
var sequelize =  new Sequelize(DB_NAME,DB_USER,DB_PASSWORD,{
  dialect: 'mysql',
  host: 'itp460.usc.edu'
})

var Post = sequelize.define('post', {
  userid: {
    type: Sequelize.INTEGER
  },
  title: {
    type: Sequelize.STRING
  },
  description: {
    type: Sequelize.STRING
  }
},{
  timestamps: false
})

app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}))
//app.use(bodyParser())

app.post('/api/1/auth', function(request, response) {
  var encodedAuth = request.headers['authorization']
  var tmp = encodedAuth.split(' ');   // Split on a space, the original auth looks like  "Basic Y2hhcmxlczoxMjM0NQ==" and we need the 2nd part
  var buf = new Buffer(tmp[1], 'base64'); // create a buffer and tell it the data coming in is base64
  var plain_auth = buf.toString();
  // At this point plain_auth = "username:password"
  var creds = plain_auth.split(':');      // split on a ':'
  var username = creds[0];
  var password = creds[1];
  console.log(creds[0]+" "+creds[1])

})

app.post('/api/1/posts', function(request, response) {
  //response.json(request.body)
  console.log(request.body)
  var post = Post.build({
    userid: request.body.userid,
    title: request.body.title,
    description: request.body.description
  })

  post.save().then(function() {
    response.json(post)
  })
})

app.get('/api/1/posts', function(request, response) {
  var promise = Post.findAll()
  promise.then(function(posts) {
    response.json(posts)
  })
})

app.delete('/api/1/posts/:id', function(request, response) {
  Post.findById(request.params.id).then(function(post) {
    if (post) {
      post.destroy().then(function(song) {
        response.json(song)
      })
    } else {
      response.status(404).json({
        message: 'Post not found'
      })
    }
  })
})

app.listen(3000)
