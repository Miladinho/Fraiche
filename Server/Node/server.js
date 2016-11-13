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
app.use(bodyParser())

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
app.listen(3000)
