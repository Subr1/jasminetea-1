// Avoid conflicts with another version
if(typeof require('module')._extensions['.coffee']==='undefined'){
  require('coffee-script/register');
}
module.exports= require('./'+require('./package.json').name+'.coffee');