{http,fs,path}= require('node-module-all') builtinLibs:true
http.createServer (req,res)->
  res.writeHead 200,'Content-type':'text/html'
  res.end fs.readFileSync path.join __dirname,'fixtures','index.html'
.listen 59798,->
  console.log 'Server running at http://localhost:59798/'
