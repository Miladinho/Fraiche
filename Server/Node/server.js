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

var User = sequelize.define('user', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true
  },
  facebookID: {
    type: Sequelize.STRING,
    field: "facebook_id"
  },
  fullname: {
    type: Sequelize.STRING
  },
  email: {
    type: Sequelize.STRING
  }
}, {
  timestamps: false
})

app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}))
//app.use(bodyParser())

app.post('/api/1/test', function(request, response) {
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

// authenticate user
app.post('/api/1/user/auth', function(request,response) {
  var user = User.findAll({
    where: {
      facebookID: request.body.facebook_id
    }
  }).then(function(value) {
    //console.log(value)
    if (value.length == 0) {
      response.status(404).json({
        message: "User not found!"
      })
    } else {
      response.status(200).json(value)
    }
  })
})

app.post('/api/1/user/create/fb', function(request,response) {
  var user = User.build({
    facebookID: request.body.facebook_id,
    fullname: request.body.fullname,
    email: request.body.email
  })

  user.save().then(function(result) {
    response.status(200).json([result])
  }, function(error) {
    console.log(error)
    response.status(400).json({
      message: error
    })
  }).catch(function(error) {
    response.status(500).json(error)
  })
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
  }).catch(function(error) {
    response.status(500).json(error)
  })
})

// get user posts
app.get('/api/1/users/:userid', function(request, response) {
  console.log(request.params)
  var userPosts = Post.findAll({
    where: {
      userid: request.params.userid
    }
  }).then(function(userPost) {
    response.status(200).json(userPost)
  }).catch(function() {
    response.status(500).json({
      message: "Error fetching posts from database."
    })
  })
})

app.get('/api/1/posts/:postid', function(request, response) {
  var post = Post.findAll({
    where: {
      id: request.params.postid
    }
  }).then(function(post) {
    response.status(200).json([post])
  }).catch(function(error) {
    response.status(500).json({
      message: error
    })
  })
})

app.get('/api/1/posts', function(request, response) {
  if (request.query.user) {
    var userPosts = Post.findAll({
      where: {
        userid: request.query.user
      }
    })
    userPosts.then(function(userPost) {
      response.status(200).json(userPost)
    }).catch(function() {
      response.status(500).json({
        message: "Error fetching posts from database."
      })
    })
  } else {
    var promise = Post.findAll()
    promise.then(function(posts) {
      response.status(200).json(posts)
    },function(error) {
      response.status(400).json({
        message: error
      })
    }).catch(function() {
      response.status(500).json({
        message: "Error fetching posts from database."
      })
    })
  }
})

app.get('/api/1/users/:id', function(request,response) {
  User.findById(request.params.id).then(function(user) {
    if (user) {
        response.json(user)
    } else {
      response.status(404).json({
        message: "User not found"
      })
    }
  }).catch(function() {
    response.status(500).json({
      message: "Error fetching users from database."
    })
  })
})

app.delete('/api/1/posts/:id', function(request, response) {
  Post.findById(request.params.id).then(function(post) {
    if (post) {
      post.destroy().then(function(post) {
        response.status(200).json(post)
      })
    } else {
      response.status(404).json({
        message: 'Post not found'
      })
    }
  }).catch(function() {
    response.status(500).json({
      message: "Error fetching posts from database."
    })
  })
})

app.put("/api/1/posts/:id", function(request,response) {

  Post.findById(request.params.id).then(function(post) {
    var title = post.title
    var description = post.description
    //console.log(title)
    if (post) {
      if (request.body.title != "") {
        title = request.body.title
      }
      if (request.body.title != "") {
        description = request.body.description
      }
      post.update({
        title: title,
        description: description
      }).then(function() {
        response.status(200).json(post)
      })
    } else {
      response.status(404).json({
        message: "Post not found."
      })
    }
  }).catch(function() {
    response.status(500).json({
      message: "Error fetching posts from database."
    })
  })

})

app.listen(3000)
